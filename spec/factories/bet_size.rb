FactoryBot.define do
  factory :bet_size do
    sequence(:bet_size) { |n| n }
    description { bet_size == 1 ? 'limp' : "#{bet_size}b" }
    color { Faker::Color.color_name }
  end
end
