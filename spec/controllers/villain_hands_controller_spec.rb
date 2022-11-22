# frozen_string_literal: true

# VillainHandsController *mostly* behaves like an AggregationPage,
# however the associations make it so that the data cannot be
# generated in the same way as other such pages, so we just do it
# manually here
RSpec.describe VillainHandsController do
  describe 'GET #index' do
    let(:aa) { Hand.find_by(hand: 'AA') }
    let(:kk) { Hand.find_by(hand: 'KK') }
    let(:hh1) { create(:hand_history, hand: aa, result: 10) }
    let(:hh2) { create(:hand_history, hand: kk, result: 20) }

    before do
      create(:villain_hand, hand: aa, hand_history: hh2)
      create(:villain_hand, hand: kk, hand_history: hh1)
      sign_in
    end

    context 'with no params' do
      let(:expected_hh_data) do
        {
          sums:   {
            'AA' => 20,
            'KK' => 10
          },
          counts: {
            'AA' => 1,
            'KK' => 1
          },
          pct_w:  {
            'AA' => 100.00,
            'KK' => 100.00
          },
          avgs:   {
            'AA' => 20,
            'KK' => 10
          }
        }
      end

      before { get :index }

      it 'renders index' do
        expect(response).to render_template('index')
      end

      it 'has response :ok' do
        expect(response).to have_http_status(:ok)
      end

      it 'assigns @hh_data' do
        expect(assigns(:hh_data)).to eq(expected_hh_data)
      end
    end

    context 'with params' do
      let(:expected_hh_data) do
        {
          sums:   {
            'KK' => 10
          },
          counts: {
            'KK' => 1
          },
          pct_w:  {
            'KK' => 100.00
          },
          avgs:   {
            'KK' => 10
          }
        }
      end

      before { get :index, params: { hand: aa.id } }

      it 'renders index' do
        expect(response).to render_template('index')
      end

      it 'has response :ok' do
        expect(response).to have_http_status(:ok)
      end

      it 'assigns @hh_data' do
        expect(assigns(:hh_data)).to eq(expected_hh_data)
      end
    end
  end
end
