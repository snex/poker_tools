# frozen_string_literal: true

FactoryBot.define do
  factory :bankroll_transaction do
    date { Faker::Date.in_date_period }
    amount { Faker::Number.number(digits: 4) }
    note { Faker::Lorem.sentence }
  end
end
