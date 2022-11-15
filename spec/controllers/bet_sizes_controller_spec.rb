RSpec.describe BetSizesController do
  describe 'GET #index' do
    before do
      BetSize.all.each_with_index do |bs, i|
        num_hands = i + 1
        (i + 1).times do |j|
          result_mod = (j % 2 == 0) ? -1 : 1
          create :hand_history, bet_size: bs, result: num_hands * result_mod
        end
      end
    end

    context 'no params' do
      it 'renders index with response 200, assigns all variables' do
        sign_in
        get :index
        expect(response).to render_template('index')
        expect(response).to have_http_status(:ok)

        expect(assigns(:sums)).to eq({
          'limp' => -1,
          '2b'   =>  0,
          '3b'   => -3,
          '4b'   =>  0,
          '5b'   => -5,
          '6b'   =>  0
        })
        expect(assigns(:counts)).to eq({
          'limp' => 1,
          '2b'   => 2,
          '3b'   => 3,
          '4b'   => 4,
          '5b'   => 5,
          '6b'   => 6
        })
        expect(assigns(:pct_w)).to eq({
          '2b'   => 50.00,
          '3b'   => 33.33,
          '4b'   => 50.00,
          '5b'   => 40.00,
          '6b'   => 50.00
        })
        expect(assigns(:avgs)).to eq({
          'limp' => -1,
          '2b'   =>  0,
          '3b'   => -1,
          '4b'   =>  0,
          '5b'   => -1,
          '6b'   =>  0
        })
      end
    end

    context 'with params' do
      it 'renders index with response 200, assigns all variables' do
        sign_in
        get :index, params: { bet_size: 3 }
        expect(response).to render_template('index')
        expect(response).to have_http_status(:ok)

        expect(assigns(:sums)).to eq({
          '3b' => -3
        })
        expect(assigns(:counts)).to eq({
          '3b' => 3
        })
        expect(assigns(:pct_w)).to eq({
          '3b' => 33.33
        })
        expect(assigns(:avgs)).to eq({
          '3b' => -1
        })
      end
    end
  end
end
