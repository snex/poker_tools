# frozen_string_literal: true

class PositionsController < AuthorizedPagesController
  include DataAggregator

  skip_before_action :verify_authenticity_token

  def index
    generate_data(:position, :'positions.position')
  end
end
