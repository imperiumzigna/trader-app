class Trade::Process
  include Interactor
  include Trade::Validator

  delegate :trade, to: :context
  delegate :bank_account, to: :context

  def call
    ActiveRecord::Base.transaction do
      update_bank_account
      trade.process!
    rescue ActiveRecord::RecordInvalid
      trade.cancel!
    end

    context.fail!(message: 'Invalid trade amount') if trade.canceled?
  end

  private
    def update_bank_account
      case trade.trade_type
      when 'buy'
        bank_account.amount -= trade.total_price
      when 'sell'
        bank_account.amount += trade.total_price
      end

      bank_account.save!
    end
end
