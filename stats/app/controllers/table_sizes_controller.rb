class TableSizesController < ApplicationController
  include Filter

  skip_before_action :verify_authenticity_token

  def index
    @table_sizes = HandHistory.includes(:hand, :position, :bet_size, :stake).joins(:table_size).group(:'table_sizes.description')
    @table_sizes = apply_filters(@table_sizes)

    @sums = @table_sizes.sum(:result)
    @counts = @table_sizes.count(:id)
    @pct_w = @table_sizes.where('result > 0').count.each_with_object({}) do |(hand, count), h|
      h[hand] = (100 * count.to_f / @counts[hand].to_f).round(2)
    end
    @avgs = @table_sizes.average(:result)
    @hands = Hand.all
    @positions = Position.all
    @bet_sizes = BetSize.all
    @stakes = Stake.all.order(:stakes_array)
  end

end
