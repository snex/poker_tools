class BetSizesController < ApplicationController

  skip_before_action :verify_authenticity_token

  def index
    @bet_sizes = HandHistory.includes(:hand, :position, :table_size, :stake).joins(:bet_size).group(:'bet_sizes.description')

    if params[:hand].present?
      @bet_sizes = @bet_sizes.where(hand: params[:hand])
    end
    if params[:position].present?
      @bet_sizes = @bet_sizes.where(position: params[:position])
    end
    if params[:table_size].present?
      @bet_sizes = @bet_sizes.where(table_size: params[:table_size])
    end
    if params[:stake].present?
      @bet_sizes = @bet_sizes.where(stake: params[:stake])
    end
    if params[:from].present? && params[:to].present?
      @bet_sizes = @bet_sizes.where(date: params[:from]..params[:to])
    elsif params[:from].present?
      @bet_sizes = @bet_sizes.where('date >= ?', params[:from])
    elsif params[:to].present?
      @bet_sizes = @bet_sizes.where('date <= ?', params[:to])
    end

    @sums = @bet_sizes.sum(:result)
    @counts = @bet_sizes.count(:id)
    @pct_w = @bet_sizes.where('result > 0').count.each_with_object({}) do |(hand, count), h|
      h[hand] = (100 * count.to_f / @counts[hand].to_f).round(2)
    end
    @avgs = @bet_sizes.average(:result)
    @hands = Hand.all
    @positions = Position.all
    @table_sizes = TableSize.all
    @stakes = Stake.all
  end

end
