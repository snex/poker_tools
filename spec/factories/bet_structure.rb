FactoryBot.define do
  factory :bet_structure do
    name { Faker::Lorem.word }
    abbreviation { Faker::Lorem.word }
  end
end
