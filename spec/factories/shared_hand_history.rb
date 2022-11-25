# frozen_string_literal: true

FactoryBot.define do
  factory :shared_hand_history do
    hand_history
    expires_at { 1.hour.from_now }
  end
end
