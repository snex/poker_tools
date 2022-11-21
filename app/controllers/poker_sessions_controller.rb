# frozen_string_literal: true

class PokerSessionsController < AuthorizedPagesController
  skip_before_action :verify_authenticity_token, only: %i[index upload chart]

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
    date = File.basename(params['file'].original_filename.split('.')[0], '.*')
    FileImporter.import(date, params['file'].path)
    redirect_to poker_sessions_path and return
  rescue StandardError => e
    render plain: e.message, status: :unprocessable_entity
  end

  def chart
    @poker_sessions = if params[:month]
                        month_chart_data
                      elsif params[:year]
                        year_chart_data
                      else
                        all_chart_data
                      end

    render 'chart_data'
  end

  private

  def month_chart_data
    PokerSession
      .where("date_part('year', start_time) = ?", params[:year])
      .where("date_part('month', start_time) = ?", params[:month])
      .order(:start_time)
  end

  def year_chart_data
    PokerSession.where("date_part('year', start_time) = ?", params[:year]).order(:start_time)
  end

  def all_chart_data
    PokerSession.order(:start_time)
  end

  def poker_sessions_params
    params.permit!
  end
end
