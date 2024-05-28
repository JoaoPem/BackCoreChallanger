FactoryBot.define do
  factory :order do
    association :user
    association :processor, factory: :product
    association :motherboard, factory: :product
    association :video_card, factory: :product
  end
end
