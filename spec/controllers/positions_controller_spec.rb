# frozen_string_literal: true

require 'support/data_aggregator'

RSpec.describe PositionsController do
  it_behaves_like 'DataAggregator', Position, :position, :'positions.position'
end
