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
    schedule_trade if trade.persisted?
  end

  private
    def create_trade
      trade = Trade.new(formated_trade_params)

      trade.save

      context.trade = trade
    rescue ActiveRecord::NotNullViolation
      trade.errors.add(:base, 'Trade attributes cannot be blank')
      context.trade = trade
      context.fail!
    end

    def schedule_trade
      if trade.timestamp >= Time.now.to_i
        ScheduleTradeJob.perform_at(trade.timestamp, trade.id)
      else
        Trade::Run.call(trade_id: trade.id)
      end
    end

    def formated_trade_params
      trade_params[:timestamp] = trade_params[:timestamp]&.to_datetime&.to_i
      trade_params[:symbol] = trade_params[:symbol].upcase

      trade_params
    end
end
