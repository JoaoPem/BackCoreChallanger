FactoryBot.define do
  factory :order_ram do
    association :order
    ram_ids { [create(:product).id] }
  end
end
