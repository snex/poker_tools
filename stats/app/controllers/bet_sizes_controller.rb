class BetSizesController < ApplicationController

  def index
    @bet_sizes = HandHistory.joins(:bet_size).group(:'bet_sizes.description')
    @sums = @bet_sizes.sum(:result)
    @counts = @bet_sizes.count(:id)
    @pct_w = @bet_sizes.where('result > 0').count.each_with_object({}) do |(hand, count), h|
      h[hand] = (100 * count.to_f / @counts[hand].to_f).round(2)
    end
    @avgs = @bet_sizes.average(:result)
  end

end
