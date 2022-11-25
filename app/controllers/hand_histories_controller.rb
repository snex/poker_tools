# frozen_string_literal: true

class HandHistoriesController < AuthorizedPagesController
  skip_before_action :verify_authenticity_token, only: %i[index chart]
  skip_before_action :require_login, only: :show

  def index
    @params = hand_histories_params
    @hand_histories = HandHistoryDatatable.new(@params)

    respond_to do |format|
      format.html
      format.json do
        render json: @hand_histories
      end
    end
  end

  def show
    @hand_history = SharedHandHistory.find_by!(uuid: params[:uuid], expires_at: Time.zone.now..).hand_history
    render layout: false
  end

  def share
    hh = HandHistory.find(params[:id])
    shh = SharedHandHistory.create!(
      hand_history: hh,
      expires_at:   1.day.from_now
    )
    redirect_to hand_history_path(shh.uuid)
  end

  def by_date; end

  def chart
    @params = hand_histories_params
    @params.delete(:length)
    @params.delete(:order)
    @params.delete(:start)
    @hand_histories = HandHistoryDatatable.new(@params).records_for_chart
    @raw_numbers = @hand_histories.pluck(:result).extend(DescriptiveStatistics)

    render 'chart_data'
  end

  private

  def hand_histories_params
    params.permit!
  end
end
