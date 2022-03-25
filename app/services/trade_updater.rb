class TradeUpdater
  include Interactor

  delegate :trade, to: :context
  delegate :trade_params, to: :context

  before do
    raise ArgumentError, 'Missing trade_id' unless context.trade_id.present?

    context.trade ||= Trade.find(context.trade_id)
  end

  def self.call(trade_id:, trade_params:)
    super
  end

  def call
    remove_scheduled_job if trade.job_id.present?
    update
    process if trade.persisted?
  end

  private
    def remove_scheduled_job
      Sidekiq::ScheduledSet.new.delete_by_jid(trade.timestamp, trade.job_id)
    end

    def update
      params = TradeSanitizer.call(trade_params: trade_params).trade_params
      trade.update!(params)
    rescue ActiveRecord::NotNullViolation, ActiveRecord::RecordInvalid
      context.fail!
    end

    def schedule
      job_id = ScheduleTradeJob.perform_at(trade.timestamp, trade.id)
      trade.update(job_id: job_id)
    end

    def process
      if trade.timestamp >= Time.now.to_i
        schedule
      else
        Trade::Run.call(trade_id: trade.id)
      end
    end
end
