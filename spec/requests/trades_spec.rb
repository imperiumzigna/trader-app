require 'rails_helper'

RSpec.describe 'Trades', type: :request do
  setup do
    FactoryBot.create(:trade_type, name: 'buy')
    FactoryBot.create(:trade_type, name: 'sell')
  end

  describe 'GET /trades' do
    let(:user) { FactoryBot.create(:user) }
    let(:uri) { '/trades' }

    before(:each) do
      sign_in user
    end

    it 'returns http success' do
      get uri
      expect(response).to have_http_status(:success)
    end

    context 'with pagination' do
      let(:trades) { FactoryBot.create_list(:trade, 30) }

      it 'returns trades' do
        get uri, params: { page: 3, per_page: 2 }
        expect(response).to have_http_status(:success)
      end
    end

    context 'with search' do
      let(:trades) { FactoryBot.create_list(:trade, 30) }
      let(:trade) { trades.first }
      let(:params) { { search: trade.account_id } }

      it 'returns trades' do
        get uri, params: params
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe 'POST /trades' do
    let(:user) { FactoryBot.create(:user) }
    let(:uri) { '/trades' }
    let(:params) { { trade: { trade_type: 'buy',
                     account_id: user.bank_accounts.first.id,
                     shares: 1,
                     price: 1.5,
                     symbol: 'AAPL',
                     timestamp: 10.minutes.ago.to_s(:db) } } }

    before(:each) do
      sign_in user
    end

    it 'creates a trade' do
      expect do
        post uri, params: params
      end.to change(Trade, :count).by(1)
    end

    it 'redirects to trades' do
      post uri, params: params
      expect(response).to redirect_to(trades_path)
    end

    context 'with invalid params' do
      let(:params) { { trade: FactoryBot.build(:trade, timestamp: nil).attributes } }

      it 'does not create a trade' do
        expect do
          post uri, params: params
        end.not_to change(Trade, :count)
      end

      it 'redirects to trades' do
        post uri, params: params
        expect(response).to redirect_to(trades_path)
      end
    end
  end
end
