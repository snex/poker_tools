# frozen_string_literal: true

class VillainHandsController < AuthorizedPagesController
  skip_before_action :verify_authenticity_token

  def index
    @hh_data = HandHistory.aggregates([villain_hands: :hand], :'hands.hand', params)
  end
end
