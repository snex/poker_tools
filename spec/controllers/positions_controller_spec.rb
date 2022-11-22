# frozen_string_literal: true

require 'support/aggregation_page'

RSpec.describe PositionsController do
  it_behaves_like 'AggregationPage', Position
end
