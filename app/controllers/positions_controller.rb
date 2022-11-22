# frozen_string_literal: true

class PositionsController < AuthorizedPagesController
  skip_before_action :verify_authenticity_token

  def index
    @hh_data = HandHistory.aggregates(:position, :'positions.position', params)
  end
end
