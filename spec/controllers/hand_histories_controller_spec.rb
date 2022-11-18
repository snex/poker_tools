# frozen_string_literal: true

RSpec.describe HandHistoriesController do
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

    it 'assigns @results_by_date' do
      expect(assigns(:results_by_date)).to be_a(ResultsByDate)
    end
  end

  describe 'GET #chart' do
    let!(:hh) { create_list(:hand_history, 2) }

    before { get :chart, format: :json }

    it 'renders chart_data' do
      expect(response).to render_template('chart_data')
    end

    it 'has response :ok' do
      expect(response).to have_http_status(:ok)
    end

    it 'assigns @params' do
      expect(assigns(:params)).to eq(
        {
          'format'     => 'json',
          'controller' => 'hand_histories',
          'action'     => 'chart'
        }
      )
    end

    it 'assigns @hand_histories' do
      expect(assigns(:hand_histories)).to match_array(hh)
    end

    it 'assigns @raw_numbers' do
      expect(assigns(:raw_numbers)).to match_array(hh.map(&:result))
    end
  end
end
