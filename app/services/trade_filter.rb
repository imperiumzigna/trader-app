require 'interactor'

class TradeFilter
  include Interactor

  delegate :params, to: :context

  def self.call(account_ids:, params:)
    super
  end

  def call
    trades = Trade.where(account_id: account_ids)

    context.trades = trades.paginate(page: params[:page], per_page: 10).order(:created_at)
  end

  private
    def account_ids
      params[:search].present? ? params[:search] : context.account_ids
    end
end
