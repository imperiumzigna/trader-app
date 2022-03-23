require 'interactor'

class TradeCreator
  include Interactor

  delegate :trade, to: :context

  def self.call(trade_params:)
    super
  end

  def call
    create_trade
    schedule_trade if trade.persisted?
  end

  private
    def create_trade
      trade = Trade.new(context.trade_params)

      trade.save

      context.trade = trade
    end

    def schedule_trade
      if trade.timestamp >= Time.now.to_i
        ScheduleTradeJob.perform_at(trade.timestamp, trade.id)
      else
        run_trade
      end
    end

    def run_trade
      service = Trade::Run.call(trade_id: trade.id)

      if service.failure? && service.trade.may_cancel?
        service.trade.cancel!
      end
    end
end
