require 'rails_helper'

RSpec.describe Trade::ValidatesOperation, type: :service do
  describe '#call' do
    setup do
      FactoryBot.create(:trade_type, name: 'buy')
      FactoryBot.create(:trade_type, name: 'sell')
    end

    let(:trade) { FactoryBot.create(:trade, trade_type: 'buy') }

    context 'when trade_type is "buy"' do
      context 'with valid amount' do
        it 'returns success' do
          service = described_class.call(trade_id: trade.id)
          expect(service.success?).to be_truthy
        end
      end

      context 'with invalid amount' do
        it 'returns failure' do
          trade.update(shares: 100, price: 10000)
          service = described_class.call(trade_id: trade.id)
          expect(service.failure?).to be_truthy
          expect(service.message).to eq('Not enough balance!')
        end
      end
    end
  end
end
