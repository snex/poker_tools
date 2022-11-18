# frozen_string_literal: true

require 'support/data_aggregator'

RSpec.describe TableSizesController do
  it_behaves_like 'DataAggregator', TableSize, :table_size, :'table_sizes.description'
end
