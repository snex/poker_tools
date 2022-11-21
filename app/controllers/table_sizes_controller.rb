# frozen_string_literal: true

class TableSizesController < AuthorizedPagesController
  skip_before_action :verify_authenticity_token

  def index
    @hh_data = HandHistory.aggregates(:table_size, :'table_sizes.description', params)
  end
end
