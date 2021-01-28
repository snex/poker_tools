class PositionsController < ApplicationController
  include Filter

  skip_before_action :verify_authenticity_token

  def index
    @positions = HandHistory.includes(:hand, :bet_size, :table_size, :stake).joins(:position).group(:'positions.position')
    @positions = apply_filters(@positions)

    @sums = @positions.sum(:result)
    @counts = @positions.count(:id)
    @pct_w = @positions.where('result > 0').count.each_with_object({}) do |(hand, count), h|
      h[hand] = (100 * count.to_f / @counts[hand].to_f).round(2)
    end
    @avgs = @positions.average(:result)
    @hands = Hand.all
    @bet_sizes = BetSize.all
    @table_sizes = TableSize.all
    @stakes = Stake.all.order(:stakes_array)
  end

end
