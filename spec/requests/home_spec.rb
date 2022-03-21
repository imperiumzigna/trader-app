require 'rails_helper'

RSpec.describe 'Home', type: :request do
  describe 'GET /home' do
    let(:user) { FactoryBot.create(:user) }

    before(:each) do
      sign_in user
    end

    it 'returns http success' do
      get '/'
      expect(response).to have_http_status(:success)
    end
  end
end
