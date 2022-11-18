# frozen_string_literal: true

require 'support/data_aggregator'

RSpec.describe StakesController do
  it_behaves_like 'DataAggregator', Stake, [poker_session: :stake], :'stakes.stake'
end
