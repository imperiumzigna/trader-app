require 'rails_helper'

RSpec.describe 'Register', type: :request do
  describe 'GET /register/sign_up' do
    it 'returns http success' do
      get '/register/sign_up'
      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST /register' do
    let(:user) { FactoryBot.build(:user, active: false) }
    let(:uri) { '/register' }

    context 'when provides valid data' do
      it 'registers succesfully' do
        post uri, params: { user: user }
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when provides invalid data' do
      it 'returns an error' do
        user.name = nil
        post uri, params: { user: user }
        expect(response).to have_http_status(:ok)
        expect(response.body).to include('Name can&#39;t be blank')
      end
    end
  end
end
