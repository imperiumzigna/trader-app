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
require 'rails_helper'

RSpec.describe TradeType, type: :model do
  it { should validate_presence_of(:name) }
end
