class HandsController < ApplicationController

  def index
    @hands = HandHistory.includes(:hand, :position, :bet_size, :table_size).joins(:hand).group(:'hands.hand')

    if params[:position].present?
      @hands = @hands.where(position: params[:position])
    end
    if params[:bet_size].present?
      @hands = @hands.where(bet_size: params[:bet_size])
    end
    if params[:table_size].present?
      @hands = @hands.where(table_size: params[:table_size])
    end

    @sums = @hands.sum(:result)
    @counts = @hands.count(:id)
    @pct_w = @hands.where('result > 0').count.each_with_object({}) do |(hand, count), h|
      h[hand] = (100 * count.to_f / @counts[hand].to_f).round(2)
    end
    @avgs = @hands.average(:result)
    @positions = Position.all
    @bet_sizes = BetSize.all
    @table_sizes = TableSize.all
  end

end
