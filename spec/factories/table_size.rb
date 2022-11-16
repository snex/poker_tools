FactoryBot.define do
  factory :table_size do
    table_size { Faker::Number.between(from: 3, to: 10) }
    description { TableSize::TABLE_SIZE_ORDER.select { |ts| ts.match?(/#{table_size}/) } }
  end
end
