class TableSizesController < ApplicationController

  skip_before_action :verify_authenticity_token

  def index
    @table_sizes = HandHistory.includes(:hand, :position, :bet_size, :stake).joins(:table_size).group(:'table_sizes.description')

    if params[:hand].present?
      @table_sizes = @table_sizes.where(hand: params[:hand])
    end
    if params[:position].present?
      @table_sizes = @table_sizes.where(position: params[:position])
    end
    if params[:bet_size].present?
      @table_sizes = @table_sizes.where(bet_size: params[:bet_size])
    end
    if params[:stake].present?
      @table_sizes = @table_sizes.where(stake: params[:stake])
    end
    if params[:from].present? && params[:to].present?
      @table_sizes = @table_sizes.where(date: params[:from]..params[:to])
    elsif params[:from].present?
      @table_sizes = @table_sizes.where('date >= ?', params[:from])
    elsif params[:to].present?
      @table_sizes = @table_sizes.where('date <= ?', params[:to])
    end
    @sums = @table_sizes.sum(:result)
    @counts = @table_sizes.count(:id)
    @pct_w = @table_sizes.where('result > 0').count.each_with_object({}) do |(hand, count), h|
      h[hand] = (100 * count.to_f / @counts[hand].to_f).round(2)
    end
    @avgs = @table_sizes.average(:result)
    @hands = Hand.all
    @positions = Position.all
    @bet_sizes = BetSize.all
    @stakes = Stake.all.order(:stakes_array)
  end

end
