# frozen_string_literal: true

RSpec.shared_examples 'DataAggregator' do |klass, join, group_by|
  describe 'GET #index' do
    before do
      klass.limit(10).custom_order.each_with_index do |k, i|
        num_hands = i + 1
        num_hands.times do |j|
          result_mod = j.even? ? -1 : 1
          create(:hand_history, "#{klass.to_s.underscore}": k, result: num_hands * result_mod)
        end
      end

      sign_in
    end

    context 'with no params' do
      before { get :index }

      it 'renders index' do
        expect(response).to render_template('index')
      end

      it 'has response 200' do
        expect(response).to have_http_status(:ok)
      end

      it 'assigns @hh_data' do
        expect(assigns(:hh_data)).to eq(generate_hh_data(join, group_by))
      end
    end

    context 'with params' do
      let(:params) { { params: { hand: 0 } } }

      before { get :index, params: params }

      it 'renders index' do
        expect(response).to render_template('index')
      end

      it 'has response 200' do
        expect(response).to have_http_status(:ok)
      end

      it 'assigns @hh_data' do
        expect(assigns(:hh_data)).to eq(generate_hh_data(join, group_by, params))
      end
    end
  end
end

def generate_hh_data(join, group_by, params = {})
  hh = HandHistory
       .includes(:hand, :position, :bet_size, :table_size, poker_session: :stake)
       .joins(join)
       .custom_filter(params)
       .group(group_by)

  sums = hh.sum(:result)
  counts = hh.count(:id)
  pct_w = hh.won.count.each_with_object({}) do |(obj, count), h|
    h[obj] = (100 * count.to_f / counts[obj].to_f).round(2)
  end
  avgs = hh.average(:result).transform_values { |v| v.round(2) }

  {
    sums:   sums,
    counts: counts,
    pct_w:  pct_w,
    avgs:   avgs
  }
end
