# frozen_string_literal: true

RSpec.describe IndexController do
  before { sign_in }

  describe 'GET #index' do
    before { get :index }

    it 'renders index' do
      expect(response).to render_template('index')
    end

    it 'has response :ok' do
      expect(response).to have_http_status(:ok)
    end
  end
end
