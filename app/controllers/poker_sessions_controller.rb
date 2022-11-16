# frozen_string_literal: true

class PokerSessionsController < AuthorizedPagesController
  skip_before_action :verify_authenticity_token, only: [:index, :upload, :chart]

  def index
    @params = poker_sessions_params
    @poker_sessions = PokerSessionDatatable.new(@params)
    @ps_records = @poker_sessions.fetch_records

    respond_to do |format|
      format.html
      format.js
      format.json do
        render json: @poker_sessions
      end
    end
  end

  def upload
    begin
      date = File.basename(params['file'].original_filename.split('.')[0], '.*')
      FileImporter.import(date, params['file'].path)
      redirect_to poker_sessions_path and return
    rescue => e
      render plain: e.message, status: :unprocessable_entity
    end
  end

  def chart
    if params[:month]
      @poker_sessions = PokerSession.where("date_part('year', start_time) = ?", params[:year]).where("date_part('month', start_time) = ?", params[:month]).order(:start_time)
    elsif params[:year]
      @poker_sessions = PokerSession.where("date_part('year', start_time) = ?", params[:year]).order(:start_time)
    else
      @poker_sessions = PokerSession.order(:start_time)
    end

    render 'chart_data'
  end

  private

  def poker_sessions_params
    params.permit!
  end
end
