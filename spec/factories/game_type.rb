# frozen_string_literal: true

FactoryBot.define do
  factory :game_type do
    stake
    bet_structure { BetStructure.all.sample(1).first }
    poker_variant { PokerVariant.all.sample(1).first }
  end
end
