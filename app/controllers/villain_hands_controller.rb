class VillainHandsController < AuthorizedPagesController
  include DataAggregator

  skip_before_action :verify_authenticity_token

  def index
    generate_data([villain_hands: :hand], :'hands.hand')
  end
end
