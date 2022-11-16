# frozen_string_literal: true

class HandsController < AuthorizedPagesController
  include DataAggregator

  skip_before_action :verify_authenticity_token

  def index
    generate_data(:hand, :'hands.hand')
  end
end
