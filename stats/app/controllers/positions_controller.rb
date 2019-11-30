class PositionsController < ApplicationController

  def index
    @positions = HandHistory.joins(:position).group(:'positions.position')
    @sums = @positions.sum(:result)
    @counts = @positions.count(:id)
    @pct_w = @positions.where('result > 0').count.each_with_object({}) do |(hand, count), h|
      h[hand] = (100 * count.to_f / @counts[hand].to_f).round(2)
    end
    @avgs = @positions.average(:result)
  end

end
