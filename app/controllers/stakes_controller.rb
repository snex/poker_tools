# frozen_string_literal: true

class StakesController < AuthorizedPagesController
  include DataAggregator

  skip_before_action :verify_authenticity_token

  def index
    generate_data([poker_session: :stake], :'stakes.stake')
  end
end
