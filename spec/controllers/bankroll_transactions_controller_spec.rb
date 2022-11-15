RSpec.describe BankrollTransactionsController do
  describe 'GET #index' do
    before do
      create :poker_session, buyin: 100, cashout: 200
      create :bankroll_transaction, amount: 500
    end

    it 'renders index with response 200, assigns all variables' do
      sign_in
      get :index
      expect(response).to render_template('index')
      expect(response).to have_http_status(:ok)

      expect(assigns(:poker_sessions)).to eq(PokerSession.all)
      expect(assigns(:amount_won)).to eq(100)
      expect(assigns(:bankroll_transactions)).to eq(BankrollTransaction.order(date: :desc))
      expect(assigns(:num_transactions)).to eq(1)
      expect(assigns(:total_amount)).to eq(600)
    end
  end
end
