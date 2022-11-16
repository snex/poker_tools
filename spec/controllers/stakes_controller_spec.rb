RSpec.describe StakesController do
  describe 'GET #index' do
    let(:ps1) { create :poker_session }
    let(:ps2) { create :poker_session }

    before do
      create :hand_history, poker_session: ps1, result:  10
      create :hand_history, poker_session: ps1, result:  20
      create :hand_history, poker_session: ps1, result: -40
      create :hand_history, poker_session: ps2, result: 100
      sign_in
    end

    context 'no params' do
      it 'renders index with response 200, assigns all variables' do
        get :index
        expect(response).to render_template('index')
        expect(response).to have_http_status(:ok)

        expect(assigns(:sums)).to eq({
          ps1.stake.stake => -10,
          ps2.stake.stake => 100
        })
        expect(assigns(:counts)).to eq({
          ps1.stake.stake => 3,
          ps2.stake.stake => 1
        })
        expect(assigns(:pct_w)).to eq({
          ps1.stake.stake =>  66.67,
          ps2.stake.stake => 100.00
        })
        expect(assigns(:avgs)).to eq({
          ps1.stake.stake =>  -3.33,
          ps2.stake.stake => 100
        })
      end
    end

    context 'with params' do
      it 'renders index with response 200, assigns all variables' do
        get :index, params: { stake: ps2.stake.id }
        expect(response).to render_template('index')
        expect(response).to have_http_status(:ok)

        expect(assigns(:sums)).to eq({
          ps2.stake.stake => 100
        })
        expect(assigns(:counts)).to eq({
          ps2.stake.stake => 1
        })
        expect(assigns(:pct_w)).to eq({
          ps2.stake.stake => 100.00
        })
        expect(assigns(:avgs)).to eq({
          ps2.stake.stake => 100
        })
      end
    end
  end
end
