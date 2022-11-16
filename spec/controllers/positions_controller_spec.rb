# frozen_string_literal: true

RSpec.describe PositionsController do
  describe 'GET #index' do
    before do
      Position.custom_order.each_with_index do |p, i|
        num_hands = i + 1
        (i + 1).times do |j|
          result_mod = (j % 2 == 0) ? -1 : 1
          create :hand_history, position: p, result: num_hands * result_mod
        end
      end

      sign_in
    end

    context 'no params' do
      it 'renders index with response 200, assigns all variables' do
        get :index
        expect(response).to render_template('index')
        expect(response).to have_http_status(:ok)

        expect(assigns(:sums)).to eq({
          'SB'       =>  -1,
          'BB'       =>   0,
          'UTG'      =>  -3,
          'UTG1'     =>   0,
          'MP'       =>  -5,
          'LJ'       =>   0,
          'HJ'       =>  -7,
          'CO'       =>   0,
          'BU'       =>  -9,
          'STRADDLE' =>   0,
          'UTG2'     => -11
        })
        expect(assigns(:counts)).to eq({
          'SB'       =>  1,
          'BB'       =>  2,
          'UTG'      =>  3,
          'UTG1'     =>  4,
          'MP'       =>  5,
          'LJ'       =>  6,
          'HJ'       =>  7,
          'CO'       =>  8,
          'BU'       =>  9,
          'STRADDLE' => 10,
          'UTG2'     => 11
        })
        expect(assigns(:pct_w)).to eq({
          'BB'       => 50.00,
          'UTG'      => 33.33,
          'UTG1'     => 50.00,
          'MP'       => 40.00,
          'LJ'       => 50.00,
          'HJ'       => 42.86,
          'CO'       => 50.00,
          'BU'       => 44.44,
          'STRADDLE' => 50.00,
          'UTG2'     => 45.45
        })
        expect(assigns(:avgs)).to eq({
          'SB'       => -1,
          'BB'       =>  0,
          'UTG'      => -1,
          'UTG1'     =>  0,
          'MP'       => -1,
          'LJ'       =>  0,
          'HJ'       => -1,
          'CO'       =>  0,
          'BU'       => -1,
          'STRADDLE' =>  0,
          'UTG2'     => -1
        })
      end
    end

    context 'with params' do
      let(:p) { Position.find_by_position('HJ') }

      it 'renders index with response 200, assigns all variables' do
        get :index, params: { position: p.id }
        expect(response).to render_template('index')
        expect(response).to have_http_status(:ok)

        expect(assigns(:sums)).to eq({
          'HJ'       =>  -7
        })
        expect(assigns(:counts)).to eq({
          'HJ'       =>  7
        })
        expect(assigns(:pct_w)).to eq({
          'HJ'       => 42.86
        })
        expect(assigns(:avgs)).to eq({
          'HJ'       => -1
        })
      end
    end
  end
end
