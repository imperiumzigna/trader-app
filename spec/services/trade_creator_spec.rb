require 'rails_helper'

RSpec.describe TradeCreator, type: :service do
  let(:user) { FactoryBot.create(:user) }
  let(:bank_account_id) { user.bank_account_ids.first }

  describe '#call' do
    setup do
      FactoryBot.create(:trade_type, name: 'buy')
      FactoryBot.create(:trade_type, name: 'sell')
    end

    context 'when params are valid' do
      context 'with immediate execution' do
        let(:params) { { trade_type: 'buy',
                         shares: 10, price: 1,
                         symbol: 'AAPL',
                         account_id: bank_account_id,
                         timestamp: 2.days.ago.to_i } }

        it 'creates trade' do
          expect { described_class.call(trade_params: params) }.to change(Trade, :count).by(1)
        end

        it 'updates bank account amount' do
          trade = described_class.call(trade_params: params).trade
          amount = trade.bank_account.amount - trade.total_price

          trade.reload

          expect(trade.bank_account.amount).to eq(amount)
          expect(trade.state).to eq('done')
        end
      end

      context 'with delayed execution' do
        let(:params) { { trade_type: 'buy',
                         shares: 10, price: 1,
                         symbol: 'AAPL',
                         account_id: bank_account_id,
                         timestamp: 5.days.from_now.to_i } }

        it 'creates trade' do
          expect { described_class.call(trade_params: params) }.to change(Trade, :count).by(1)
        end

        it 'schedules trade for processing' do
          trade = described_class.call(trade_params: params).trade
          expect(trade.state).to eq('pending')
        end
      end
    end

    context 'when params are invalid' do
      let(:params) { { trade_type: 'buy',
                       shares: 100, price: 0,
                       symbol: 'AAPL',
                       account_id: bank_account_id,
                       timestamp: Time.now.to_i } }

      it 'does not create trade' do
        expect { described_class.call(trade_params: params) }.to change(Trade, :count).by(0)
      end

      it 'returns trade with errors' do
        trade = described_class.call(trade_params: params).trade
        expect(trade.errors.full_messages).to eq(['Price must be greater than 0'])
      end
    end
  end
end
