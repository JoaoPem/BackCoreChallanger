require 'rails_helper'

RSpec.describe Order, type: :model do
  let(:user) { create(:user) }
  let(:processor) { create(:product, name: 'Core i5') }
  let(:motherboard) { create(:product, name: 'ASRock Steel Legend', specifications: "{ \"processadores_suportados\": [\"Intel\"] }") }
  let(:incompatible_processor) { create(:product, name: 'Ryzen 5', specifications: "{ \"marca\": \"AMD\" }") }
  let(:ram) { create(:product, name: 'Kingston HyperX 16 GB', specifications: "{ \"tamanho\": 16 }") }
  let(:video_card) { create(:product, name: 'Evga Geforce RTX 2060 6GB') }

  it "is valid with compatible components" do
    order = Order.new(user: user, processor: processor, motherboard: motherboard, order_ram: OrderRam.new(ram_ids: [ram.id]), video_card: video_card)
    expect(order).to be_valid
  end

  it "is invalid if the processor is not compatible with the motherboard" do
    order = Order.new(user: user, processor: incompatible_processor, motherboard: motherboard, order_ram: OrderRam.new(ram_ids: [ram.id]), video_card: video_card)
    expect(order).not_to be_valid
  end
end
