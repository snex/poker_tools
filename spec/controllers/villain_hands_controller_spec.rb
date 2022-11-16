# frozen_string_literal: true

RSpec.describe VillainHandsController do
  describe 'GET #index' do
    let(:aa) { Hand.find_by_hand('AA') }
    let(:kk) { Hand.find_by_hand('KK') }
    let(:hh1) { create :hand_history, hand: aa, result: 10 }
    let(:hh2) { create :hand_history, hand: kk, result: 20 }

    before do
      create :villain_hand, hand: aa, hand_history: hh2
      create :villain_hand, hand: kk, hand_history: hh1
      sign_in
    end

    context 'no params' do
      it 'renders index with response 200, assigns all variables' do
        get :index
        expect(response).to render_template('index')
        expect(response).to have_http_status(:ok)

        expect(assigns(:sums)).to eq({
          'AA' =>  20,
          'KK' =>  10
        })
        expect(assigns(:counts)).to eq({
          'AA' => 1,
          'KK' => 1
        })
        expect(assigns(:pct_w)).to eq({
          'AA' => 100.00,
          'KK' => 100.00
        })
        expect(assigns(:avgs)).to eq({
          'AA' => 20,
          'KK' => 10
        })
      end
    end

    context 'with params' do
      it 'renders index with response 200, assigns all variables' do
        get :index, params: { hand: aa.id }
        expect(response).to render_template('index')
        expect(response).to have_http_status(:ok)

        expect(assigns(:sums)).to eq({
          'KK' => 10
        })
        expect(assigns(:counts)).to eq({
          'KK' => 1
        })
        expect(assigns(:pct_w)).to eq({
          'KK' => 100.00
        })
        expect(assigns(:avgs)).to eq({
          'KK' => 10
        })
      end
    end
  end
end
