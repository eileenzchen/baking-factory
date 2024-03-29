FactoryBot.define do
  factory :item do
    name "Honey Wheat Bread"
    description "A most tasty treat from the bakers at Bread Express. Your family will love it!"
    # picture nil
    category "bread"
    units_per_item 1
    weight 1.0
    active true
    picture { Rack::Test::UploadedFile.new(Rails.root.join('app/assets/images/honey-wheat-bread.jpg'), 'image/jpeg') }
  end
end
