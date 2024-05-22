require 'rails_helper'

RSpec.describe Order, type: :model do
  # Criando as categorias necessárias
  let(:processor_category) { Category.create!(name: "Processador") }
  let(:motherboard_category) { Category.create!(name: "Placa Mãe") }
  let(:ram_category) { Category.create!(name: "Memória RAM") }
  let(:video_card_category) { Category.create!(name: "Placa de Vídeo") }

  let(:processor) { Product.create!(name: "Core i5", specifications: '{ "marca": "Intel" }', category: processor_category) }
  let(:motherboard) { Product.create!(name: "Asus ROG", specifications: '{ "processadores_suportados": ["Intel"], "slots_memoria": 4, "memoria_suportada": 64, "video_integrado": true }', category: motherboard_category) }
  let(:ram) { Product.create!(name: "Kingston HyperX 16 GB", specifications: '{ "tamanho": 16 }', category: ram_category) }
  let(:video_card) { Product.create!(name: "Nvidia GeForce GTX 1050 Ti", specifications: '{ "memoria": 4 }', category: video_card_category) }

  it 'is valid with compatible components' do
    order = Order.new(processor: processor, motherboard: motherboard, ram: ram, video_card: video_card)
    expect(order).to be_valid
  end

  it 'is invalid if the processor is not compatible with the motherboard' do
    incompatible_processor = Product.create!(name: "Ryzen 5", specifications: "{ \"marca\": \"AMD\" }", category: processor_category)
    order = Order.new(processor: incompatible_processor, motherboard: motherboard, ram: ram, video_card: video_card)
    expect(order).not_to be_valid
  end
end
