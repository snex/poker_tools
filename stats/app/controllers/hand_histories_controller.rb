class HandHistoriesController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:index, :chart]

  def index
    @params = hand_histories_params
    @hand_histories = HandHistoryDatatable.new(hand_histories_params)

    respond_to do |format|
      format.html
      format.json do
        render json: @hand_histories
      end
    end
  end

  def by_date
    @hh = HandHistory.includes(:hand, :position, :bet_size, :table_size)

    if params[:hand].present?
      @hh = @hh.where(hand: params[:hand])
    end
    if params[:position].present?
      @hh = @hh.where(position: params[:position])
    end
    if params[:bet_size].present?
      @hh = @hh.where(bet_size: params[:bet_size])
    end
    if params[:table_size].present?
      @hh = @hh.where(table_size: params[:table_size])
    end
    @results_by_month = @hh.group_by_month(:date).sum(:result)
    @hands = Hand.all
    @positions = Position.all
    @bet_sizes = BetSize.all
    @table_sizes = TableSize.all
  end

  def chart
    @params = hand_histories_params
    @params.delete(:length)
    @params.delete(:order)
    @params.delete(:start)
    @hand_histories = HandHistoryDatatable.new(@params).get_records_for_chart
    @raw_numbers = @hand_histories.pluck(:result).extend(DescriptiveStatistics)

    render 'chart_data'
  end

  private

  def hand_histories_params
    params.permit!
  end
end
