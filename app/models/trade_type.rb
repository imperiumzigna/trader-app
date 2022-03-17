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
class TradeType < ApplicationRecord
  self.primary_key = :name

  validates_presence_of :name
end
