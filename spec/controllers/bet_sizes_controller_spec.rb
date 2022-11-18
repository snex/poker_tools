# frozen_string_literal: true

require 'support/data_aggregator'

RSpec.describe BetSizesController do
  it_behaves_like 'DataAggregator', BetSize, :bet_size, :'bet_sizes.description'
end
