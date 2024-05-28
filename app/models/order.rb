class Order < ApplicationRecord

  # Estou estabelecendo associações com outros modelos. 
  belongs_to :user
  belongs_to :processor, class_name: 'Product', optional: true
  belongs_to :motherboard, class_name: 'Product', optional: true
  belongs_to :order_ram, optional: true
  belongs_to :video_card, class_name: 'Product', optional: true

  # Validações para garantir que estes atributos estejam presentes antes de salvar uma order.
  validates :user, presence: { message: I18n.t('activerecord.errors.models.order.attributes.user.blank') }
  validates :processor, presence: { message: I18n.t('activerecord.errors.models.order.attributes.processor.blank') }
  validates :motherboard, presence: { message: I18n.t('activerecord.errors.models.order.attributes.motherboard.blank') }

  # Validações customizadas.
  validate :validate_processor_compatibility
  validate :validate_ram_selection
  validate :validate_video_card_requirement

  private

  def validate_processor_compatibility
    # Se o processador ou a placa-mãe forem nulos, a validação é interrompida.
    return if processor.nil? || motherboard.nil?

    # Obtém a marca do processador a partir de suas especificações.
    processor_brand = JSON.parse(processor.specifications)['marca']
    # Obtém a lista de processadores suportados pela placa-mãe a partir das especificações da placa-mãe.
    supported_processors = JSON.parse(motherboard.specifications)['processadores_suportados']

    # Se a marca do processador não estiver na lista de processadores suportados, adiciona um erro.
    unless supported_processors.include?(processor_brand)
      errors.add(:processor, I18n.t('activerecord.errors.models.order.messages.incompatible_processor'))
    end
  end

  # As demais validações são parecidas, irei comentar apenas os diferenciais.
  def validate_ram_selection

    return if motherboard.nil?

    # Se a order_ram estiver ausente, dispara um erro e interrompe a validação.
    if order_ram.nil? || order_ram.ram_ids.empty?
      errors.add(:order_ram, I18n.t('activerecord.errors.models.order.attributes.order_ram.required'))
      return
    end

    ram_slots = JSON.parse(motherboard.specifications)['slots_memoria']
    max_ram_supported = JSON.parse(motherboard.specifications)['memoria_suportada']
    # Calcula o tamanho total da memória RAM selecionada.
    selected_ram_size = order_ram.ram_ids.sum { |ram_id| JSON.parse(Product.find(ram_id).specifications)['tamanho'] }

    # Dispara um error se a quantidade de RAM selecionada exceder o número de slots.
    if order_ram.ram_ids.size > ram_slots
      errors.add(:order_ram, I18n.t('activerecord.errors.models.order.messages.ram_exceeds_slots'))
    end
    # Dispara um error se a GB da RAM selecionada exceder.
    if selected_ram_size > max_ram_supported
      errors.add(:order_ram, I18n.t('activerecord.errors.models.order.messages.ram_exceeds_supported'))
    end
  end

  def validate_video_card_requirement
    return if motherboard.nil?

    video_integrado = JSON.parse(motherboard.specifications)['video_integrado']
    if !video_integrado && video_card.nil?
      errors.add(:video_card, I18n.t('activerecord.errors.models.order.attributes.video_card.required'))
    end

    if video_integrado && !video_card.nil?
      errors.add(:video_card, I18n.t('activerecord.errors.models.order.attributes.video_card.not_required'))
    end
  end
end
