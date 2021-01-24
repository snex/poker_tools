class PositionsController < ApplicationController

  skip_before_action :verify_authenticity_token

  def index
    @positions = HandHistory.includes(:hand, :bet_size, :table_size, :stake).joins(:position).group(:'positions.position')

    if params[:hand].present?
      @positions = @positions.where(hand: params[:hand])
    end
    if params[:bet_size].present?
      @positions = @positions.where(bet_size: params[:bet_size])
    end
    if params[:table_size].present?
      @positions = @positions.where(table_size: params[:table_size])
    end
    if params[:stake].present?
      @positions = @positions.where(stake: params[:stake])
    end
    if params[:from].present? && params[:to].present?
      @positions = @positions.where(date: params[:from]..params[:to])
    elsif params[:from].present?
      @positions = @positions.where('date >= ?', params[:from])
    elsif params[:to].present?
      @positions = @positions.where('date <= ?', params[:to])
    end

    @sums = @positions.sum(:result)
    @counts = @positions.count(:id)
    @pct_w = @positions.where('result > 0').count.each_with_object({}) do |(hand, count), h|
      h[hand] = (100 * count.to_f / @counts[hand].to_f).round(2)
    end
    @avgs = @positions.average(:result)
    @hands = Hand.all
    @bet_sizes = BetSize.all
    @table_sizes = TableSize.all
    @stakes = Stake.all
  end

end
