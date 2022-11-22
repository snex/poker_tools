# frozen_string_literal: true

require 'support/aggregation_page'

RSpec.describe TableSizesController do
  it_behaves_like 'AggregationPage', TableSize
end
