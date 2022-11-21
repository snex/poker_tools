# frozen_string_literal: true

class StakesController < AuthorizedPagesController
  skip_before_action :verify_authenticity_token

  def index
    @hh_data = HandHistory.aggregates([poker_session: :stake], :'stakes.stake', params)
  end
end
