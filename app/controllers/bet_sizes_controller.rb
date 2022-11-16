class BetSizesController < AuthorizedPagesController
  include DataAggregator

  skip_before_action :verify_authenticity_token

  def index
    generate_data(:bet_size, :'bet_sizes.description')
  end
end
