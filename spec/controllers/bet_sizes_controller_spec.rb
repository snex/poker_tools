# frozen_string_literal: true

require 'support/aggregation_page'

RSpec.describe BetSizesController do
  it_behaves_like 'AggregationPage', BetSize
end
