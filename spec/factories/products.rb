FactoryBot.define do
  factory :product do
    name { "Product" }
    specifications { "{ \"marca\": \"Brand\" }" }
    category_id { 1 }
  end
end
