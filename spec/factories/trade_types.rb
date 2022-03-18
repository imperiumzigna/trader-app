# == Schema Information
#
# Table name: trade_types
#
#  name       :string           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_trade_types_on_name  (name)
#
FactoryBot.define do
  factory :trade_type do
    name { 'buy' } # TradeTypes are 'buy' or 'sell'
  end
end
