require 'rails_helper'

RSpec.describe TradeSanitizer, type: :service do
  context 'when trade.timestamp is a String' do
    let(:params) { { timestamp: '2018-01-01T00:00:00.000Z' } }

    it 'converts timestamp to integer epoch' do
      expect(TradeSanitizer.call(trade_params: params).trade_params[:timestamp]).to eq(1514764800)
    end
  end

  context 'when trade.symbol is lowercase' do
    let(:params) { { symbol: 'aapl' } }

    it 'converts symbol to uppercase' do
      expect(TradeSanitizer.call(trade_params: params).trade_params[:symbol]).to eq('AAPL')
    end
  end
end
