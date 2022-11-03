class PokerSessionsController < AuthorizedPagesController
  include Filter

  skip_before_action :verify_authenticity_token, only: [:index, :upload]

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

  def upload
    begin
      date = File.basename(params['file'].original_filename.split('.')[0], '.*')
      HandHistory.import(date, params['file'].path)
      render plain: '' and return
    rescue => e
      render plain: e.message, status: :unprocessable_entity
      raise e
    end
  end

  private

  def poker_sessions_params
    params.permit!
  end
end
