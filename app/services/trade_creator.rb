require 'interactor'

class TradeCreator
  include Interactor

  delegate :trade, to: :context
  delegate :trade_params, to: :context

  def self.call(trade_params:)
    super
  end

  def call
    create_trade
    process_trade if trade.persisted?
  end

  private
    def create_trade
      params = TradeSanitizer.call(trade_params: trade_params).trade_params
      trade = Trade.new(params)

      trade.save!

      context.trade = trade
    rescue ActiveRecord::NotNullViolation, ActiveRecord::RecordInvalid
      trade.errors.add(:base, 'Trade attributes cannot be blank')
      context.trade = trade
      context.fail!
    end

    def schedule_trade
      job_id = ScheduleTradeJob.perform_at(trade.timestamp, trade.id)
      trade.update(job_id: job_id)
    end

    def process_trade
      if trade.timestamp >= Time.now.to_i
        schedule_trade
      else
        Trade::Run.call(trade_id: trade.id)
      end
    end
end
