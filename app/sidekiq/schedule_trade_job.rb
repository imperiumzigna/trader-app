class ScheduleTradeJob
  include Sidekiq::Job

  sidekiq_options retry: false, queue: :trade

  def perform(trade_id)
    Trade::Run.call(trade_id: trade_id)
  end
end
