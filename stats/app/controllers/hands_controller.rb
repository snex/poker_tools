class HandsController < ApplicationController

  skip_before_action :verify_authenticity_token

  def index
    @hands = HandHistory.includes(:hand, :position, :bet_size, :table_size, :stake).joins(:hand).group(:'hands.hand')

    if params[:position].present?
      @hands = @hands.where(position: params[:position])
    end
    if params[:bet_size].present?
      @hands = @hands.where(bet_size: params[:bet_size])
    end
    if params[:table_size].present?
      @hands = @hands.where(table_size: params[:table_size])
    end
    if params[:stake].present?
      @hands = @hands.where(stake: params[:stake])
    end
    if params[:from].present? && params[:to].present?
      @hands = @hands.where(date: params[:from]..params[:to])
    elsif params[:from].present?
      @hands = @hands.where('date >= ?', params[:from])
    elsif params[:to].present?
      @hands = @hands.where('date <= ?', params[:to])
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
    @stakes = Stake.all
  end

end
