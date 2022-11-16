RSpec.describe HandsController do
  describe 'GET #index' do
    let(:aa) { Hand.find_by_hand('AA') }
    let(:kk) { Hand.find_by_hand('KK') }

    before do
      create :hand_history, hand: aa, result:  10
      create :hand_history, hand: aa, result:  20
      create :hand_history, hand: aa, result: -40
      create :hand_history, hand: kk, result: 100
      sign_in
    end

    context 'no params' do
      it 'renders index with response 200, assigns all variables' do
        get :index
        expect(response).to render_template('index')
        expect(response).to have_http_status(:ok)

        expect(assigns(:sums)).to eq({
          'AA' => -10,
          'KK' => 100
        })
        expect(assigns(:counts)).to eq({
          'AA' => 3,
          'KK' => 1
        })
        expect(assigns(:pct_w)).to eq({
          'AA' =>  66.67,
          'KK' => 100.00
        })
        expect(assigns(:avgs)).to eq({
          'AA' =>  -3.33,
          'KK' => 100
        })
      end
    end

    context 'with params' do
      it 'renders index with response 200, assigns all variables' do
        get :index, params: { hand: aa.id }
        expect(response).to render_template('index')
        expect(response).to have_http_status(:ok)

        expect(assigns(:sums)).to eq({
          'AA' => -10
        })
        expect(assigns(:counts)).to eq({
          'AA' => 3
        })
        expect(assigns(:pct_w)).to eq({
          'AA' => 66.67
        })
        expect(assigns(:avgs)).to eq({
          'AA' => -3.33
        })
      end
    end
  end
end
