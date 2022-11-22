# frozen_string_literal: true

FactoryBot.define do
  factory :hand do
    hand { Hand::HAND_ORDER.sample }
  end
end
