FactoryBot.define do
  factory :hand_history do
    result { Faker::Number.between(from: -1000, to: 1000) }
    hand { Hand.all.sample(1).first }
    position { Position.all.sample(1).first }
    bet_size { BetSize.all.sample(1).first }
    table_size { TableSize.all.sample(1).first }
    poker_session
    note { Faker::Lorem.paragraph }

    trait :with_flop do
      flop { Faker::Lorem.word }
    end

    trait :with_showdown do
      showdown { true }
    end
  end
end