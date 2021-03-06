require 'rails_helper'

RSpec.describe 'BankAccounts', type: :request do
  describe 'GET /bank_accounts' do
    let(:user) { FactoryBot.create(:user) }
    let(:uri) { '/bank_accounts' }

    before(:each) do
      sign_in user
    end

    it 'returns http success' do
      get uri
      expect(response).to have_http_status(:success)
    end

    context 'with pagination' do
      let(:bank_accounts) { FactoryBot.create_list(:bank_account, 30, user: user) }

      it 'returns bank_accounts' do
        get uri, params: { page: 3, per_page: 2 }
        expect(response).to have_http_status(:success)
      end
    end

    context 'with search' do
      let(:bank_accounts) { FactoryBot.create_list(:bank_account, 30, user: user) }
      let(:bank_account) { bank_accounts.first }
      let(:params) { { search: bank_account.id } }

      it 'returns bank_accounts' do
        get uri, params: params
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe 'GET /bank_accounts/:id' do
    let(:user) { FactoryBot.create(:user) }
    let(:bank_account) { FactoryBot.create(:bank_account, user: user) }
    let(:uri) { "/bank_accounts/#{bank_account.id}" }

    before(:each) do
      sign_in user
    end

    it 'returns http success' do
      get uri
      expect(response).to have_http_status(:success)
    end

    context 'when bank_account was not found' do
      let(:uri) { '/bank_accounts/not_found' }

      it 'redirects to index with error' do
        get uri
        expect(response).to have_http_status(:redirect)
        follow_redirect!
        expect(response).to have_http_status(:ok)
        expect(response.body).to include('Bank account not found')
      end
    end
  end
end
