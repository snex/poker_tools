# frozen_string_literal: true

RSpec.describe TableSizesController do
  describe 'GET #index' do
    before do
      TableSize.custom_order.each_with_index do |t, i|
        num_hands = i + 1
        (i + 1).times do |j|
          result_mod = (j % 2 == 0) ? -1 : 1
          create :hand_history, table_size: t, result: num_hands * result_mod
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
          '10/9/8 handed' => -1,
          '7 handed'      =>  0,
          '6 handed'      => -3,
          '5 handed'      =>  0,
          '4 handed'      => -5,
          '3 handed'      =>  0,
          'Heads Up'      => -7
        })
        expect(assigns(:counts)).to eq({
          '10/9/8 handed' => 1,
          '7 handed'      => 2,
          '6 handed'      => 3,
          '5 handed'      => 4,
          '4 handed'      => 5,
          '3 handed'      => 6,
          'Heads Up'      => 7
        })
        expect(assigns(:pct_w)).to eq({
          '7 handed'      => 50.00,
          '6 handed'      => 33.33,
          '5 handed'      => 50.00,
          '4 handed'      => 40.00,
          '3 handed'      => 50.00,
          'Heads Up'      => 42.86
        })
        expect(assigns(:avgs)).to eq({
          '10/9/8 handed' => -1,
          '7 handed'      =>  0,
          '6 handed'      => -1,
          '5 handed'      =>  0,
          '4 handed'      => -1,
          '3 handed'      =>  0,
          'Heads Up'      => -1
        })
      end
    end

    context 'with params' do
      let(:t) { TableSize.find_by_description('Heads Up') }

      it 'renders index with response 200, assigns all variables' do
        get :index, params: { table_size: t.id }
        expect(response).to render_template('index')
        expect(response).to have_http_status(:ok)

        expect(assigns(:sums)).to eq({
          'Heads Up' =>  -7
        })
        expect(assigns(:counts)).to eq({
          'Heads Up' =>  7
        })
        expect(assigns(:pct_w)).to eq({
          'Heads Up' => 42.86
        })
        expect(assigns(:avgs)).to eq({
          'Heads Up' => -1
        })
      end
    end
  end
end
