# frozen_string_literal: true

FactoryBot.define do
  factory :stake do
    stake { "#{Faker::Number.number(digits: 4)}/#{Faker::Number.number(digits: 4)}" }
  end
end
