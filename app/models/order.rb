class Order < ApplicationRecord
  
  belongs_to :user
  belongs_to :processor, class_name: 'Product', optional: true
  belongs_to :motherboard, class_name: 'Product', optional: true
  belongs_to :ram, class_name: 'Product', optional: true
  belongs_to :video_card, class_name: 'Product', optional: true

  validates :processor, presence: true
  validates :motherboard, presence: true
  validates :ram, presence: true

  validate :validate_processor_compatibility
  validate :validate_ram_selection
  validate :validate_video_card_requirement

  private

  def validate_processor_compatibility
    return if processor.nil? || motherboard.nil?

    processor_brand = JSON.parse(processor.specifications)['marca']
    supported_processors = JSON.parse(motherboard.specifications)['processadores_suportados']

    if supported_processors.is_a?(Array)
      unless supported_processors.include?(processor_brand)
        errors.add(:processor, "não é compatível com a placa-mãe selecionada")
      end
    else
      errors.add(:motherboard, "não tem processadores suportados definidos corretamente")
    end
  end

  def validate_ram_selection
    return if ram.nil? || motherboard.nil?

    ram_slots = JSON.parse(motherboard.specifications)['slots_memoria']
    max_ram_supported = JSON.parse(motherboard.specifications)['memoria_suportada']
    selected_ram_size = JSON.parse(ram.specifications)['tamanho']

    if selected_ram_size.to_i > max_ram_supported.to_i
      errors.add(:ram, "selecionada excede o total suportado pela placa-mãe")
    end
  end

  def validate_video_card_requirement
    return if motherboard.nil?

    video_integrado = JSON.parse(motherboard.specifications)['video_integrado']
    if video_integrado == false && video_card.nil?
      errors.add(:video_card, "é necessária, pois a placa-mãe não possui vídeo integrado")
    end
  end
end
