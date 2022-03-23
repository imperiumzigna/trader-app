module Trade::Validator
  extend ActiveSupport::Concern

  included do
    include Interactor

    # This will catch all exception happening in the validator
    around do |interactor|
      interactor.call
    rescue StandardError => e
      context.fail!(error: e)
    end

    before do
      raise ArgumentError, 'Missing trade_id' unless context.trade_id.present?

      context.trade ||= Trade.find(context.trade_id)
      context.bank_account ||= context.trade.bank_account
    end
  end
end
