# frozen_string_literal: true

FactoryBot.define do
  factory :position do
    position { Position::POSITION_ORDER.sample }
  end
end
