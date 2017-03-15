FactoryGirl.define do
  factory :order_detail do
    menu_item_name "menu_name"
    price { Faker::Number.positive }
    quantity { Faker::Number.positive }
    veg { Faker::Boolean.boolean }
    total_price { Faker::Number.positive }
    
    association :order
    association :terminal
  end
end
