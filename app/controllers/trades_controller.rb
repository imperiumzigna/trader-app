class TradesController < ApplicationController
  before_action :set_trade, only: [:show, :edit, :update]
  layout 'base'

  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found

  def index
    @trades = TradeFilter.call(account_ids: current_user.bank_account_ids, params: params).trades
  end

  def new
    @trade = Trade.new
  end

  def show
  end

  def edit
  end

  def update
    TradeUpdater.call(trade_id: @trade.id, trade_params: trade_params)

    flash[:alert] = 'Trade was successfully updated.'

    redirect_to trades_path
  end

  def create
    TradeCreator.call(trade_params: trade_params)

    flash[:alert] = 'Trade was successfully created.'

    redirect_to trades_path
  end

  private
    def trade_params
      params.require(:trade).permit(:trade_type, :account_id, :shares, :price, :symbol, :timestamp)
    end

    def render_not_found
      flash[:alert] = 'Trade not found'

      redirect_to trades_path
    end

    def set_trade
      @trade = Trade.find(params[:id])
    end
end
