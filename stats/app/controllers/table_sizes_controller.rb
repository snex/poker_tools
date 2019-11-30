class TableSizesController < ApplicationController

  def index
    @table_sizes = HandHistory.joins(:table_size).group(:'table_sizes.description')
    @sums = @table_sizes.sum(:result)
    @counts = @table_sizes.count(:id)
    @pct_w = @table_sizes.where('result > 0').count.each_with_object({}) do |(hand, count), h|
      h[hand] = (100 * count.to_f / @counts[hand].to_f).round(2)
    end
    @avgs = @table_sizes.average(:result)
  end

end
