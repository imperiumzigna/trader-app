class TradeSanitizer
  include Interactor

  delegate :trade_params, to: :context

  def self.call(trade_params:)
    super
  end

  def call
    enforce_timestamp_integer
    enforce_symbol_upcase
  end

  private
    def enforce_timestamp_integer
      if trade_params[:timestamp].is_a?(String) && trade_params[:timestamp].present?
        trade_params[:timestamp] = trade_params[:timestamp].to_datetime.to_i
      end
    end

    def enforce_symbol_upcase
      trade_params[:symbol] = trade_params[:symbol].upcase if trade_params[:symbol].present?
    end
end
