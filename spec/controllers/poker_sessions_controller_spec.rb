# frozen_string_literal: true

RSpec.describe PokerSessionsController do
  before { sign_in }

  describe 'GET #index' do
    context 'with format .html' do
      before { get :index }

      it 'renders index' do
        expect(response).to render_template('index')
      end

      it 'has response :ok' do
        expect(response).to have_http_status(:ok)
      end

      it 'assigns @poker_sessions' do
        expect(assigns(:poker_sessions)).to be_a(PokerSessionDatatable)
      end
    end

    context 'with format .js' do
      before { get :index, format: :js }

      it 'renders index' do
        expect(response).to render_template('index')
      end

      it 'has response :ok' do
        expect(response).to have_http_status(:ok)
      end

      it 'assigns @poker_sessions' do
        expect(assigns(:poker_sessions)).to be_a(PokerSessionDatatable)
      end
    end

    context 'with format .json' do
      before { get :index, format: :json }

      it 'returns a PokerSessionDatatable in the response body' do
        expect(response.body).to eq(PokerSessionDatatable.new({}).to_json)
      end

      it 'has response :ok' do
        expect(response).to have_http_status(:ok)
      end

      it 'assigns @poker_sessions' do
        expect(assigns(:poker_sessions)).to be_a(PokerSessionDatatable)
      end
    end
  end

  describe 'POST #upload' do
    context 'when file is good' do
      before do
        create(
          :game_type,
          stake:         Stake.find_or_create_by!(stake: '1/2'),
          bet_structure: BetStructure.find_by(name: 'No Limit'),
          poker_variant: PokerVariant.find_by(name: 'Texas Holdem')
        )
        post :upload, params: { file: Rack::Test::UploadedFile.new('spec/data/file_importer/import_basic.txt') }
      end

      it 'imports an uploaded file' do
        expect(PokerSession.count).to eq(1)
      end

      it 'redirects to index' do
        expect(response).to redirect_to(poker_sessions_path)
      end

      it 'has response :found' do
        expect(response).to have_http_status(:found)
      end
    end

    context 'when file is bad' do
      before do
        post :upload, params: { file: Rack::Test::UploadedFile.new('spec/data/file_importer/import_bad_game_name.txt') }
      end

      it 'returns an error in the body' do
        expect(response.body).to eq('Unknown Game Type: 1/2 UWOT')
      end

      it 'has response :unprocessable_entity' do
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'GET #chart' do
    let!(:ps1) { create(:poker_session, start_time: DateTime.parse('2022-01-01 12:00 PST')) }
    let!(:ps2) { create(:poker_session, start_time: DateTime.parse('2022-02-01 12:00 PST')) }
    let(:params) { {} }

    before do
      create(:poker_session, start_time: DateTime.parse('2021-02-01 12:00 PST'))
      get :chart, format: :json, params: params
    end

    it 'renders chart_data' do
      expect(response).to render_template('chart_data')
    end

    it 'has response :ok' do
      expect(response).to have_http_status(:ok)
    end

    context 'with no params' do
      it 'assigns @poker_sessions' do
        expect(assigns(:poker_sessions)).to eq(PokerSession.order(:start_time))
      end
    end

    context 'when only year param is passed' do
      let(:params) { { year: '2022' } }

      it 'assigns @poker_sessions' do
        expect(assigns(:poker_sessions)).to eq([ps1, ps2])
      end
    end

    context 'when month and year params are passed' do
      let(:params) { { year: '2022', month: '1' } }

      it 'assigns @poker_sessions' do
        expect(assigns(:poker_sessions)).to eq([ps1])
      end
    end
  end
end
