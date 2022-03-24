class TradesController < ApplicationController
  layout 'base'

  def index
    @trades = TradeFilter.call(account_ids: current_user.bank_account_ids, params: params).trades
  end

  def new
    @trade = Trade.new
  end

  def create
    service = TradeCreator.call(trade_params: trade_params)

    if service.success?
      redirect_to trades_path, notice: 'Trade was successfully created.'
    else
      @trade = service.trade
      render :new
    end
  end

  private
    def trade_params
      params.require(:trade).permit(:trade_type, :account_id, :shares, :price, :symbol, :timestamp)
    end
end
