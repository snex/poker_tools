# frozen_string_literal: true

RSpec.describe IndexController do
  describe 'GET #index' do
    it 'renders index with response 200' do
      sign_in
      get :index
      expect(response).to render_template('index')
      expect(response).to have_http_status(:ok)
    end
  end
end
