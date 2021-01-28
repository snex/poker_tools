class BetSizesController < ApplicationController
  include Filter

  skip_before_action :verify_authenticity_token

  def index
    @bet_sizes = HandHistory.includes(:hand, :position, :table_size, :stake).joins(:bet_size).group(:'bet_sizes.description')
    @bet_sizes = apply_filters(@bet_sizes)

    @sums = @bet_sizes.sum(:result)
    @counts = @bet_sizes.count(:id)
    @pct_w = @bet_sizes.where('result > 0').count.each_with_object({}) do |(hand, count), h|
      h[hand] = (100 * count.to_f / @counts[hand].to_f).round(2)
    end
    @avgs = @bet_sizes.average(:result)
    @hands = Hand.all
    @positions = Position.all
    @table_sizes = TableSize.all
    @stakes = Stake.all.order(:stakes_array)
  end

end
