# frozen_string_literal: true

RSpec.describe VillainHand do
  it { is_expected.to belong_to :hand_history }
  it { is_expected.to belong_to :hand }
end
