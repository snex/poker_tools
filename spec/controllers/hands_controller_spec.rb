# frozen_string_literal: true

require 'support/aggregation_page'

RSpec.describe HandsController do
  it_behaves_like 'AggregationPage', Hand
end
