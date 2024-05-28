require 'rails_helper'

RSpec.describe "Orders", type: :request do
  let(:user) { create(:user) }
  let(:processor) { create(:product, name: 'Core i5') }
  let(:motherboard) { create(:product, name: 'ASRock Steel Legend', specifications: "{ \"processadores_suportados\": [\"Intel\"], \"slots_memoria\": 4, \"memoria_suportada\": 64 }") }
  let(:ram) { create(:product, name: 'Kingston HyperX 16 GB', specifications: "{ \"tamanho\": 16 }") }
  let(:video_card) { create(:product, name: 'Evga Geforce RTX 2060 6GB') }

  let(:valid_attributes) {
    {
      processor_id: processor.id,
      motherboard_id: motherboard.id,
      ram_ids: [ram.id],
      user_id: user.id
    }
  }

  let(:invalid_attributes) {
    {
      processor_id: nil,
      motherboard_id: nil,
      ram_ids: [],
      user_id: nil
    }
  }

  describe "POST /orders" do
    context "with valid parameters" do
      it "creates a new Order" do
        expect {
          post orders_path, params: { order: valid_attributes }, as: :json
        }.to change(Order, :count).by(1)
      end

      it "renders a JSON response with the new order" do
        post orders_path, params: { order: valid_attributes }, as: :json
        expect(response).to have_http_status(:created)
        expect(response.content_type).to match(a_string_including("application/json"))
        expect(response.body).to include("Core i5")
      end
    end

    context "with invalid parameters" do
      it "does not create a new Order" do
        expect {
          post orders_path, params: { order: invalid_attributes }, as: :json
        }.to change(Order, :count).by(0)
      end

      it "renders a JSON response with errors for the new order" do
        post orders_path, params: { order: invalid_attributes }, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to match(a_string_including("application/json"))
        expect(response.body).to include("não pode estar em branco")
      end
    end
  end
end
