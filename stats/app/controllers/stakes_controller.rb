class StakesController < ApplicationController
  include Filter

  skip_before_action :verify_authenticity_token

  def index
    @stakes = HandHistory.includes(:hand, :position, :bet_size, :table_size).joins(:stake).group(:'stakes.stake')
    @stakes = apply_filters(@stakes)

    @sums = @stakes.sum(:result)
    @counts = @stakes.count(:id)
    @pct_w = @stakes.where('result > 0').count.each_with_object({}) do |(hand, count), h|
      h[hand] = (100 * count.to_f / @counts[hand].to_f).round(2)
    end
    @avgs = @stakes.average(:result)
    @hands = Hand.all
    @positions = Position.all
    @bet_sizes = BetSize.all
    @table_sizes = TableSize.all
  end

end
