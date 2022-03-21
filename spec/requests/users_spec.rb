require 'rails_helper'

RSpec.describe 'Users', type: :request do
  describe 'GET /profile' do
    let(:user) { FactoryBot.create(:user) }

    before(:each) do
      sign_in user
    end

    it 'returns http success' do
      get '/profile'
      expect(response).to have_http_status(:success)
    end
  end

  describe 'PUT /users/:id' do
    let(:user) { FactoryBot.create(:user) }
    let(:uri) { "/users/#{user.id}" }

    before(:each) do
      sign_in user
    end

    it 'updates user info' do
      put uri, params: { user: { name: 'New name' } }
      expect(response).to have_http_status(:redirect)
      expect(user.reload.name).to eq('New name')
    end

    it 'returns an error' do
      put uri, params: { user: { name: nil } }
      expect(user.errors.full_messages).to include('Name can\'t be blank')
      expect(response).to have_http_status(:redirect)
    end
  end
end
