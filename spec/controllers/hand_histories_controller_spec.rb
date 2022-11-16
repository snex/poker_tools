# frozen_string_literal: true

RSpec.describe HandHistoriesController do
  before { sign_in }

  describe 'GET #index' do
    context '.html' do
      it 'renders index with response 200, assigns all variables' do
        get :index
        expect(response).to render_template('index')
        expect(response).to have_http_status(:ok)

        expect(assigns(:hand_histories)).to be_a(HandHistoryDatatable)
      end
    end

    context '.json' do
      it 'renders index with response 200, assigns all variables' do
        get :index, format: :json
        expect(response).to have_http_status(:ok)

        expect(assigns(:hand_histories)).to be_a(HandHistoryDatatable)
        expect(response.body).to eq(HandHistoryDatatable.new({}).to_json)
      end
    end
  end

  describe 'GET #by_date' do
    it 'renders by_date with response 200, assigns all variables' do
      get :by_date
      expect(response).to render_template('by_date')
      expect(response).to have_http_status(:ok)

      expect(assigns(:results_by_date)).to be_a(ResultsByDate)
    end
  end

  describe 'GET #chart' do
    let(:hh) { create_list :hand_history, 2 }

    it 'renders chart with response 200, assigns all variables' do
      get :chart, format: :json
      expect(response).to render_template('chart_data')
      expect(response).to have_http_status(:ok)
    end
  end
end
