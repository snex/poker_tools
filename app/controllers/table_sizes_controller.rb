class TableSizesController < AuthorizedPagesController
  include DataAggregator

  skip_before_action :verify_authenticity_token

  def index
    generate_data(:table_size, :'table_sizes.description')
  end
end
