# frozen_string_literal: true

class HandsController < AuthorizedPagesController
  skip_before_action :verify_authenticity_token

  def index
    @hh_data = HandHistory.aggregates(:hand, :'hands.hand', params)
  end
end
