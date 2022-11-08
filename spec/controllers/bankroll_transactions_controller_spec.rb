require 'support/features/clearance_helpers'

RSpec.describe BankrollTransactionsController do
  include Features::ClearanceHelpers

  describe 'GET #index' do
    before do
      create(:user, email: 'user@example.com', password: 'password')
      sign_in_with 'user@example.com', 'password'
      get :index
    end

    it { should respond_with(200) }
    it { should render_template('index') }
  end
end
