class StakesController < ApplicationController

  skip_before_action :verify_authenticity_token

  def index
    @stakes = HandHistory.includes(:hand, :position, :bet_size, :table_size).joins(:stake).group(:'stakes.stake')

    if params[:hand].present?
      @stakes = @stakes.where(hand: params[:hand])
    end
    if params[:position].present?
      @stakes = @stakes.where(position: params[:position])
    end
    if params[:bet_size].present?
      @stakes = @stakes.where(bet_size: params[:bet_size])
    end
    if params[:table_size].present?
      @stakes = @stakes.where(table_size: params[:table_size])
    end
    if params[:from].present? && params[:to].present?
      @stakes = @stakes.where(date: params[:from]..params[:to])
    elsif params[:from].present?
      @stakes = @stakes.where('date >= ?', params[:from])
    elsif params[:to].present?
      @stakes = @stakes.where('date <= ?', params[:to])
    end
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
