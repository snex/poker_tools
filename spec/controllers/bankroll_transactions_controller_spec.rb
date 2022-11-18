# frozen_string_literal: true

RSpec.describe BankrollTransactionsController do
  describe 'GET #index' do
    before do
      create(:poker_session, buyin: 100, cashout: 200)
      create(:bankroll_transaction, amount: 500)
      sign_in
      get :index
    end

    it 'renders index' do
      expect(response).to render_template('index')
    end

    it 'has response :ok' do
      expect(response).to have_http_status(:ok)
    end

    it 'assigns @bankroll' do
      expect(assigns(:bankroll)).to be_a(Bankroll)
    end
  end
end
