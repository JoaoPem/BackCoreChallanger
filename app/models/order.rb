class Order < ApplicationRecord
  belongs_to :user
  belongs_to :processor, class_name: 'Product', optional: true
  belongs_to :motherboard, class_name: 'Product', optional: true
  belongs_to :order_ram, optional: true
  belongs_to :video_card, class_name: 'Product', optional: true

  validates :processor, presence: true
  validates :motherboard, presence: true

  validate :validate_processor_compatibility
  validate :validate_ram_selection
  validate :validate_video_card_requirement

  before_save :assign_order_ram_id

  private

  def validate_processor_compatibility
    return if processor.nil? || motherboard.nil?

    processor_brand = JSON.parse(processor.specifications)['marca']
    supported_processors = JSON.parse(motherboard.specifications)['processadores_suportados']

    unless supported_processors.include?(processor_brand)
      errors.add(:processor, "não é compatível com a placa-mãe selecionada")
    end
  end

  def validate_ram_selection
    return if order_ram.nil? || motherboard.nil?

    ram_slots = JSON.parse(motherboard.specifications)['slots_memoria']
    max_ram_supported = JSON.parse(motherboard.specifications)['memoria_suportada']
    selected_ram_size = order_ram.ram_ids.sum { |ram_id| JSON.parse(Product.find(ram_id).specifications)['tamanho'] }

    if order_ram.ram_ids.size > ram_slots
      errors.add(:rams, "excede o número de slots de memória disponíveis")
    end

    if selected_ram_size > max_ram_supported
      errors.add(:rams, "selecionada excede o total suportado pela placa-mãe")
    end
  end

  def validate_video_card_requirement
    return if motherboard.nil?

    video_integrado = JSON.parse(motherboard.specifications)['video_integrado']
    if !video_integrado && video_card.nil?
      errors.add(:video_card, "é necessária, pois a placa-mãe não possui vídeo integrado")
    end

    if video_integrado && !video_card.nil?
      errors.add(:video_card, "não é necessária, pois a placa-mãe possui vídeo integrado")
    end
  end

  def assign_order_ram_id
    self.ram_id = order_ram&.id
  end
end
