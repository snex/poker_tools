# frozen_string_literal: true

require 'support/aggregation_page'

RSpec.describe StakesController do
  before do
    create(:stake, stake: '5/10')
    create(:stake, stake: '2/5')
    create(:stake, stake: '1/2')
    create(:stake, stake: '100/200')
  end

  it_behaves_like 'AggregationPage', Stake
end
