# frozen_string_literal: true

class BetSizesController < AuthorizedPagesController
  skip_before_action :verify_authenticity_token

  def index
    @hh_data = HandHistory.aggregates(:bet_size, :'bet_sizes.description', params)
  end
end
