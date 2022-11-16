FactoryBot.define do
  factory :hand do
    hand { Hand::HAND_ORDER.sample }
  end
end
