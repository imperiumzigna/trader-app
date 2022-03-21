require 'rails_helper'

RSpec.describe 'Login', type: :request do
  describe 'GET /login' do
    it 'returns http success' do
      get '/'
      expect(response).to have_http_status(:redirect)
    end
  end

  describe 'POST /login' do
    let(:user) { FactoryBot.create(:user, active: false) }

    context 'when user is not active' do
      it 'redirects to login page' do
        post '/login', params: { user: { email: user.email, password: 'Password1*' } }
        expect(response).to have_http_status(:redirect)
      end
    end

    context 'when user is active' do
      it 'redirects to home page' do
        user.update(active: true)
        post '/login', params: { user: { email: user.email, password: 'Password1*' } }
        expect(response).to have_http_status(:redirect)
      end
    end
  end
end
