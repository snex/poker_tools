# frozen_string_literal: true

RSpec.describe PokerSessionsController do
  before { sign_in }

  describe 'GET #index' do
    context '.html' do
      it 'renders index with response 200, assigns all variables' do
        get :index
        expect(response).to render_template('index')
        expect(response).to have_http_status(:ok)

        expect(assigns(:poker_sessions)).to be_a(PokerSessionDatatable)
      end
    end

    context '.json' do
      it 'renders index with response 200, assigns all variables' do
        get :index, format: :json
        expect(response).to have_http_status(:ok)

        expect(assigns(:poker_sessions)).to be_a(PokerSessionDatatable)
        expect(response.body).to eq(PokerSessionDatatable.new({}).to_json)
      end
    end
  end

  describe 'POST #upload' do
    context 'file is good' do
      it 'imports an uploaded file and redirects to index' do
        post :upload, params: { file: Rack::Test::UploadedFile.new('spec/data/file_importer/import_basic.txt') }
        expect(response).to redirect_to(poker_sessions_path)
        expect(response).to have_http_status(:found)
      end
    end

    context 'file is bad' do
      it 'raises an exception and returns status :unprocessable_entity' do
        post :upload, params: { file: Rack::Test::UploadedFile.new('spec/data/file_importer/import_bad_game_name.txt') }
        expect(response.body).to eq('Unknown Game Type: UWOT')
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'GET #chart' do
    let!(:ps1) { create :poker_session, start_time: DateTime.parse('2022-01-01 12:00 PST') }
    let!(:ps2) { create :poker_session, start_time: DateTime.parse('2022-02-01 12:00 PST') }
    let!(:ps3) { create :poker_session, start_time: DateTime.parse('2021-02-01 12:00 PST') }

    it 'renders chart with response 200' do
      get :chart, format: :json
      expect(response).to render_template('chart_data')
      expect(response).to have_http_status(:ok)
    end

    context 'no params' do
      it 'assigns all variables' do
        get :chart, format: :json
        expect(assigns(:poker_sessions)).to eq(PokerSession.order(:start_time))
      end
    end

    context 'year param passed' do
      it 'assigns all variables' do
        get :chart, format: :json, params: { year: '2022' }
        expect(assigns(:poker_sessions)).to eq([ps1, ps2])
      end
    end

    context 'month and year params passed' do
      it 'assigns all variables' do
        get :chart, format: :json, params: { year: '2022', month: '1' }
        expect(assigns(:poker_sessions)).to eq([ps1])
      end
    end
  end
end
