# frozen_string_literal: true

require 'support/data_aggregator'

RSpec.describe VillainHandsController do
  it_behaves_like 'DataAggregator', VillainHand, [villain_hands: :hand], 'hands.hand'
end
