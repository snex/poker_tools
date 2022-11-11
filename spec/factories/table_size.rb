FactoryBot.define do
  factory :table_size do
    table_size { Faker::Number.number(digits: 1) }
    description { "#{table_size} handed" }
  end
end
