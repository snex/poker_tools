# frozen_string_literal: true

RSpec.shared_examples 'AggregationPage' do |klass|
  describe 'GET #index' do
    before do
      generate_hh_data(klass)
      sign_in
    end

    context 'with no params' do
      before { get :index }

      it 'renders index' do
        expect(response).to render_template('index')
      end

      it 'has response :ok' do
        expect(response).to have_http_status(:ok)
      end

      it 'assigns @hh_data' do
        expect(assigns(:hh_data)).to eq(expected(klass))
      end
    end

    context 'with params' do
      let(:params) { { hand: 0 } }

      before { get :index, params: params }

      it 'renders index' do
        expect(response).to render_template('index')
      end

      it 'has response :ok' do
        expect(response).to have_http_status(:ok)
      end

      it 'assigns @hh_data' do
        expect(assigns(:hh_data)).to eq(expected(klass, params))
      end
    end
  end
end

def generate_hh_data(klass)
  klass.limit(10).custom_order.each_with_index do |k, i|
    num_hands = i + 1
    num_hands.times do |j|
      result_mod = j.even? ? -1 : 1
      create(:hand_history, "#{klass.to_s.underscore}": k, result: num_hands * result_mod)
    end
  end
end

def expected(klass, params = {})
  if params.empty?
    JSON.parse(
      file_fixture("aggregation_page/#{klass.to_s.underscore}.json").read.strip
    ).symbolize_keys
  else
    { sums: {}, counts: {}, pct_w: {}, avgs: {} }
  end
end
