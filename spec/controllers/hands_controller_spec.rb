# frozen_string_literal: true

require 'support/data_aggregator'

RSpec.describe HandsController do
  it_behaves_like 'DataAggregator', Hand, :hand, :'hands.hand'
end
