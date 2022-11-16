FactoryBot.define do
  factory :poker_session do
    buyin { Faker::Number.number(digits: 4) }
    cashout { Faker::Number.number(digits: 4) }
    start_time { Faker::Time.between(from: DateTime.now - 1.day, to: DateTime.now - 1.hour) }
    end_time { Faker::Time.between(from: start_time + 1.minute, to: DateTime.now) }
    hands_dealt { Faker::Number.number(digits: 3) }
    stake
    bet_structure { BetStructure.all.sample(1).first }
    poker_variant { PokerVariant.all.sample(1).first }

    trait :with_hand_histories do
      hand_histories { build_list :hand_history, 5 }
    end

    trait :with_hand_histories_flops do
      hand_histories { build_list(:hand_history, 3) + build_list(:hand_history, 2, :with_flop) }
    end

    trait :with_hand_histories_showdowns do
      hand_histories { build_list(:hand_history, 3) + build_list(:hand_history, 2, :with_showdown) }
    end
  end
end
