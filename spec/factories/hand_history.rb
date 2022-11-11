FactoryBot.define do
  factory :hand_history do
    result { Faker::Number.between(from: -1000, to: 1000) }
    hand
    position
    bet_size
    table_size
    poker_session

    trait :with_flop do
      flop { Faker::Lorem.word }
    end

    trait :with_showdown do
      showdown { true }
    end
  end
end
