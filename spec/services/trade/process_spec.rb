require 'rails_helper'

RSpec.describe Trade::Process, type: :service do
  describe '#call' do
    setup do
      FactoryBot.create(:trade_type, name: 'buy')
      FactoryBot.create(:trade_type, name: 'sell')
    end

    let(:buy) { FactoryBot.create(:trade, trade_type: 'buy') }
    let(:sell) { FactoryBot.create(:trade, trade_type: 'sell') }

    context 'when trade_type is "buy"' do
      context 'with valid trade' do
        it 'updates bank account amount' do
          described_class.call(trade_id: buy.id)
          amount = buy.bank_account.amount - buy.total_price
          buy.reload

          expect(buy.bank_account.amount).to eq(amount)
        end

        it 'updates trade state' do
          described_class.call(trade_id: buy.id)
          expect(buy.reload.state).to eq('done')
        end
      end

      context 'with invalid trade' do
        before(:each) do
          buy.bank_account.update(amount: 0)
        end

        it 'does not update bank account amount' do
          expect { described_class.call(trade_id: buy.id) }.to_not change(buy.bank_account, :amount)
        end

        it 'cancel the trade' do
          service = described_class.call(trade_id: buy.id)

          expect(buy.reload.state).to eq('canceled')
          expect(service.message).to eq('Invalid trade amount')
        end
      end
    end

    context 'when trade_type is "sell"' do
      context 'with valid trade' do
        it 'updates bank account amount' do
          described_class.call(trade_id: sell.id)
          amount = sell.bank_account.amount + sell.total_price
          sell.reload

          expect(sell.bank_account.amount).to eq(amount)
        end

        it 'updates trade state' do
          described_class.call(trade_id: sell.id)
          expect(sell.reload.state).to eq('done')
        end
      end
    end
  end
end
