class ScheduleTradeJob
  include Sidekiq::Job

  sidekiq_options retry: false, queue: :trade

  def perform(trade_id)
    service = Trade::Run.call(trade_id: trade_id)

    # Make sure to cancel the trade if the service fails
    if service.failure? && service.trade.may_cancel?
      service.trade.cancel!
    end
  end
end
