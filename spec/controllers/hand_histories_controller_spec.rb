# frozen_string_literal: true

RSpec.describe HandHistoriesController do
  before { |spec| sign_in unless spec.metadata[:nologin] }

  describe 'GET #show', type: :feature do
    render_views

    context 'when shared_hand_history does not exist' do
      it 'throws a 404', :nologin do
        expect { visit '/abc123' }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'when shared_hand_history exists and is not expired' do
      let(:shh) { create(:shared_hand_history) }

      before { visit "/#{shh.uuid}" }

      it 'renders show', :nologin do
        expect(response).to render_template('show', layout: [])
      end

      it 'has response :ok', :nologin do
        expect(response).to have_http_status(:ok)
      end

      it 'has the hand_history result', :nologin do
        expect(page).to have_text("Amount Won/Lost: #{shh.hand_history.result}")
      end

      it 'has the hand_history note', :nologin do
        expect(page).to have_text("Hand History: #{shh.hand_history.note.gsub("\n", ' ')}")
      end
    end

    context 'when shared_hand_history exists but is expired' do
      let(:shh) { create(:shared_hand_history, expires_at: 1.hour.ago) }

      it 'throws a 404', :nologin do
        expect { visit "/#{shh.uuid}" }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe 'POST #share' do
    let(:hh) { create(:hand_history) }

    before { post :share, params: { id: hh.id } }

    it 'creates a SharedHandHistory' do
      expect(SharedHandHistory.count).to eq(1)
    end

    it 'redirects to hand_history_path with the SharedHandHistory uuid' do
      shh = SharedHandHistory.first
      expect(response).to redirect_to(hand_history_path(shh.uuid))
    end

    it 'has response :found' do
      expect(response).to have_http_status(:found)
    end
  end

  describe 'GET #index' do
    context 'with format .html' do
      before { get :index }

      it 'renders index' do
        expect(response).to render_template('index')
      end

      it 'has response :ok' do
        expect(response).to have_http_status(:ok)
      end

      it 'assigns @hand_histories' do
        expect(assigns(:hand_histories)).to be_a(HandHistoryDatatable)
      end
    end

    context 'with format .json' do
      before { get :index, format: :json }

      it 'returns a HandHistoryDataTable in the body' do
        expect(response.body).to eq(HandHistoryDatatable.new({}).to_json)
      end

      it 'has response :ok' do
        expect(response).to have_http_status(:ok)
      end

      it 'assigns @hand_histories' do
        expect(assigns(:hand_histories)).to be_a(HandHistoryDatatable)
      end
    end
  end

  describe 'GET #by_date' do
    before { get :by_date }

    it 'renders by_date' do
      expect(response).to render_template('by_date')
    end

    it 'has response :ok' do
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET #chart' do
    let(:expected_params) do
      {
        'format'     => 'json',
        'controller' => 'hand_histories',
        'action'     => 'chart'
      }
    end
    let!(:hh) { create_list(:hand_history, 2) }

    before { get :chart, format: :json }

    it 'renders chart_data' do
      expect(response).to render_template('chart_data')
    end

    it 'has response :ok' do
      expect(response).to have_http_status(:ok)
    end

    it 'assigns @params' do
      expect(assigns(:params)).to eq(expected_params)
    end

    it 'assigns @hand_histories' do
      expect(assigns(:hand_histories)).to match_array(hh)
    end

    it 'assigns @raw_numbers' do
      expect(assigns(:raw_numbers)).to match_array(hh.map(&:result))
    end
  end
end
