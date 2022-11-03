class PokerSessionsController < ApplicationController
  include Filter

  skip_before_action :verify_authenticity_token, only: [:index]

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

  def show
  end

  private

  def poker_sessions_params
    params.permit!
  end
end
