class Order < ApplicationRecord

  # Associações com outros modelos
  belongs_to :user
  belongs_to :processor, class_name: 'Product', optional: true
  belongs_to :motherboard, class_name: 'Product', optional: true
  belongs_to :video_card, class_name: 'Product', optional: true

  # Associações com OrderRam através da tabela intermediária OrderOrderRam (N para N)
  has_many :order_order_rams, dependent: :destroy
  has_many :order_rams, through: :order_order_rams, dependent: :destroy

  # Validações para garantir que estes atributos estejam presentes antes de salvar uma order
  validates :user, presence: { message: I18n.t('activerecord.errors.models.order.attributes.user.blank') }
  validates :processor, presence: { message: I18n.t('activerecord.errors.models.order.attributes.processor.blank') }
  validates :motherboard, presence: { message: I18n.t('activerecord.errors.models.order.attributes.motherboard.blank') }

  # Validações customizadas
  validate :validate_processor_compatibility
  validate :validate_ram_selection
  validate :validate_video_card_requirement

  # Criar uma ordem com RAMs associadas.
  def self.create_with_rams(user:, processor:, motherboard:, ram_ids:, video_card: nil)
    # Cria uma nova ordem com os parâmetros
    order = Order.new(user: user, processor: processor, motherboard: motherboard, video_card: video_card)

    # Verifica se os IDs de RAM são válidos e não nulos
    if ram_ids.nil? || ram_ids.empty?
      order.errors.add(:order_rams, "Deve selecionar pelo menos uma memória RAM.")
      return order
    end

    # Verificar a validade antes de salvar
    order_ram = OrderRam.new(ram_ids: ram_ids)
    order.order_rams << order_ram

    # Verifica a validade do pedido
    if order.valid?
      order.save
      order_ram.save
      OrderOrderRam.create(order: order, order_ram: order_ram)
    else
      # Se o pedido for inválido, não salva as associações
      order.order_rams.clear
    end

    order
  end

  private

  # Compatibilidade do processador com a placa-mãe
  def validate_processor_compatibility
    # Se o processador ou a placa-mãe forem nulos, a validação é interrompida
    return if processor.nil? || motherboard.nil?

    # Obtém a marca do processador a partir de suas especificações
    processor_brand = JSON.parse(processor.specifications)['marca']
    # Obtém a lista de processadores suportados pela placa-mãe a partir das especificações da placa-mãe
    supported_processors = JSON.parse(motherboard.specifications)['processadores_suportados']

    # Se a marca do processador não estiver na lista de processadores suportados, adiciona um erro
    unless supported_processors.include?(processor_brand)
      errors.add(:processor, I18n.t('activerecord.errors.models.order.messages.incompatible_processor'))
    end
  end

  # Verificar a seleção de RAM
  def validate_ram_selection
    # Se a placa-mãe for nula, a validação é interrompida
    return if motherboard.nil?

    # Se a lista de RAMs associadas estiver vazia, adiciona um erro
    if order_rams.empty?
      errors.add(:order_rams, I18n.t('activerecord.errors.models.order.attributes.order_ram.required'))
      return
    end

    # Obtém o número de slots de RAM e a quantidade máxima de RAM suportada pela placa-mãe
    ram_slots = JSON.parse(motherboard.specifications)['slots_memoria']
    max_ram_supported = JSON.parse(motherboard.specifications)['memoria_suportada']
    # Calcula o tamanho total da memória RAM selecionada
    selected_ram_size = order_rams.flat_map(&:ram_ids).sum { |ram_id| JSON.parse(Product.find(ram_id).specifications)['tamanho'] }

    # Verifica se a quantidade de RAM selecionada excede o número de slots disponíveis
    if order_rams.flat_map(&:ram_ids).size > ram_slots
      errors.add(:order_rams, I18n.t('activerecord.errors.models.order.messages.ram_exceeds_slots'))
    end

    # Verifica se o tamanho total da memória RAM selecionada excede o suportado pela placa-mãe
    if selected_ram_size > max_ram_supported
      errors.add(:order_rams, I18n.t('activerecord.errors.models.order.messages.ram_exceeds_supported'))
    end
  end

  # Validação personalizada para verificar a necessidade de uma placa de vídeo
  def validate_video_card_requirement
    # Se a placa-mãe for nula, a validação é interrompida
    return if motherboard.nil?

    # Obtém a informação se a placa-mãe possui vídeo integrado
    video_integrado = JSON.parse(motherboard.specifications)['video_integrado']
    # Se a placa-mãe não possuir vídeo integrado e não houver uma placa de vídeo associada, adiciona o erro
    if !video_integrado && video_card.nil?
      errors.add(:video_card, I18n.t('activerecord.errors.models.order.attributes.video_card.required'))
    end

    # Se a placa-mãe possuir vídeo integrado e houver uma placa de vídeo associada, adiciona o erro
    if video_integrado && !video_card.nil?
      errors.add(:video_card, I18n.t('activerecord.errors.models.order.attributes.video_card.not_required'))
    end
  end
end
