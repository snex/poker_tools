# frozen_string_literal: true

FactoryBot.define do
  factory :table_size do
    table_size { Faker::Number.between(from: 3, to: 10) }
    description { TableSize::TABLE_SIZE_ORDER.grep(/#{table_size}/) }
  end
end
