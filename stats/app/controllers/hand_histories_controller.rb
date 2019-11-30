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
    @results_by_month = HandHistory.group_by_month(:date).sum(:result)
  end

  def chart
    @params = hand_histories_params
    @params.delete(:length)
    @params.delete(:order)
    @params.delete(:start)
    @hand_histories = HandHistoryDatatable.new(@params).records.unscope(:limit, :offset).order(:date, :id)
    @raw_numbers = @hand_histories.pluck(:result).extend(DescriptiveStatistics)

    render 'chart_data'
  end

  private

  def hand_histories_params
    params.permit!
  end
end
