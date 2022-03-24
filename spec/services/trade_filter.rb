require 'rails_helper'

RSpec.describe TradeFilter, type: :service do
  let(:user) { FactoryBot.create(:user) }
  let(:account_ids) { user.bank_account_ids }

  setup do
    FactoryBot.create(:trade_type, name: 'buy')
    FactoryBot.create(:trade_type, name: 'sell')
    FactoryBot.create_list(:trade, 5, account_id: account_ids.first)
  end

  describe '#call' do
    context 'when params[:search] is present' do
      let(:params) { { search: account_ids.first } }

      it 'returns filtered trades' do
        trades = described_class.call(account_ids: user.bank_account_ids, params: params).trades

        expect(trades.first.account_id).to eq(account_ids.first)
      end
    end

    context 'when params[:search] was not found' do
      let(:params) { { search: 'not_found' } }

      it 'returns empty array' do
        trades = described_class.call(account_ids: user.bank_account_ids, params: params).trades

        expect(trades).to be_empty
      end
    end

    context 'when params[:search] is not present' do
      let(:params) { {} }

      it 'returns all user trades' do
        trade_ids = described_class.call(account_ids: user.bank_account_ids, params: params).trades.pluck(:id)

        expect(trade_ids).to match_array(user.trade_ids)
      end
    end
  end
end
