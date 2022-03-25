require 'rails_helper'

RSpec.describe TradeUpdater, type: :service do
  setup do
    FactoryBot.create(:trade_type, name: 'buy')
    FactoryBot.create(:trade_type, name: 'sell')
  end

  describe '#call' do
    let(:user) { FactoryBot.create(:user) }
    let(:account_id) { user.bank_account_ids.first }

    context 'when params are valid' do
      context 'with immediate execution' do
        let(:trade) { FactoryBot.create(:trade,
          account_id: account_id,
          timestamp: 10.minutes.ago.to_i) }
        let(:params) { { symbol: 'XXL' } }

        it 'updates trade' do
          service = described_class.call(trade_id: trade.id, trade_params: params)
          expect(service.trade.symbol).to eq('XXL')
        end

        it 'updates bank account amount' do
          result = described_class.call(trade_id: trade.id, trade_params: params).trade
          amount = result.bank_account.amount - result.total_price

          result.reload

          expect(result.bank_account.amount).to eq(amount)
          expect(result.state).to eq('done')
        end
      end

      context 'with delayed execution' do
        let(:delayed_trade) { FactoryBot.create(:trade, timestamp: 1.day.from_now.to_i, job_id: 'adasd') }
        let(:params) { { symbol: 'XXL' } }

        before(:each) do
          allow_any_instance_of(Sidekiq::ScheduledSet).to receive(:delete_by_jid).and_return(true)
          allow(ScheduleTradeJob).to receive(:perform_at).and_return('xxxxx')
        end

        it 'cancel scheduled job' do
          expect_any_instance_of(Sidekiq::ScheduledSet).to receive(:delete_by_jid).with(delayed_trade.timestamp, 'adasd')
          described_class.call(trade_id: delayed_trade.id, trade_params: params)
        end

        it 'schedules trade for processing' do
          expect(ScheduleTradeJob).to receive(:perform_at).with(delayed_trade.timestamp, delayed_trade.id)
          result = described_class.call(trade_id: delayed_trade.id, trade_params: params).trade
          expect(result.job_id).to eq('xxxxx')
        end
      end
    end

    context 'when params are invalid' do
      let(:trade) { FactoryBot.create(:trade,
        account_id: account_id,
        timestamp: 10.minutes.ago.to_i) }
      let(:params) { { trade_type: 'buy',
                       shares: 100, price: 0,
                       symbol: 'AAPL',
                       account_id: account_id } }

      it 'does not update trade' do
        service = described_class.call(trade_id: trade.id, trade_params: params)
        expect(service).to be_failure
      end

      it 'returns trade with errors' do
        result = described_class.call(trade_id: trade.id, trade_params: params).trade
        expect(result.errors.full_messages).to eq(['Price must be greater than 0'])
      end
    end
  end
end
