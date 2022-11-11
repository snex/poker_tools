FactoryBot.define do
  factory :poker_variant do
    name { Faker::Lorem.word }
    abbreviation { Faker::Lorem.word }
  end
end
