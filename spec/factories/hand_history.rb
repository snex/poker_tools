# frozen_string_literal: true

FactoryBot.define do
  factory :hand_history do
    result { Faker::Number.between(from: -1000, to: 1000) }
    hand { Hand.all.sample(1).first }
    position { Position.all.sample(1).first }
    bet_size { BetSize.all.sample(1).first }
    table_size { TableSize.all.sample(1).first }
    note { Faker::Lorem.paragraph }

    transient do
      stake { nil }
    end

    poker_session do
      if stake.present?
        association(:poker_session, stake: Stake.find_or_initialize_by(stake: stake))
      else
        association(:poker_session)
      end
    end

    trait :with_flop do
      flop { Faker::Lorem.word }
    end

    trait :with_turn do
      turn { Faker::Lorem.word }
    end

    trait :with_river do
      river { Faker::Lorem.word }
    end

    trait :with_showdown do
      showdown { true }
    end

    trait :with_all_in do
      all_in { true }
    end

    trait :with_villain_hands do
      villain_hands { build_list(:villain_hand, 2) }
    end
  end
end
