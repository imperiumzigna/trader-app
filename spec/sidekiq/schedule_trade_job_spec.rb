require 'rails_helper'
RSpec.describe ScheduleTradeJob, type: :job do
  setup do
    FactoryBot.create(:trade_type, name: 'buy')
    FactoryBot.create(:trade_type, name: 'sell')
  end

  let(:user) { FactoryBot.create(:user) }

  describe '#perform' do
    let(:account_ids) { user.bank_account_ids }
    let(:trade) { FactoryBot.create(:trade, account_id: account_ids.first) }

    it 'process a trade' do
      ScheduleTradeJob.perform_at(Time.now.to_i, trade.id)
      expect(ScheduleTradeJob).to have_enqueued_sidekiq_job(trade.id)
    end
  end
end
