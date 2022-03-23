
  class Trade::ValidatesOperation
    include Interactor
    include Trade::Validator

    delegate :trade, to: :context
    delegate :bank_account, to: :trade

    def call
      validate_buy
    end

    private
      def validate_buy
        if trade.trade_type == 'buy' && trade.total_price > bank_account.amount
          context.fail!(message: 'Not enough balance!')
        end
      end
  end
