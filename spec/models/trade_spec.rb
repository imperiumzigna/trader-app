# == Schema Information
#
# Table name: trades
#
#  id         :bigint           not null, primary key
#  price      :float            not null
#  shares     :integer          not null
#  state      :string           not null
#  symbol     :string           not null
#  timestamp  :integer          not null
#  trade_type :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  account_id :integer          not null
#
# Foreign Keys
#
#  fk_rails_...  (account_id => bank_accounts.id) ON DELETE => nullify
#  fk_rails_...  (trade_type => trade_types.name) ON DELETE => nullify
#
require 'rails_helper'

RSpec.describe Trade, type: :model do
  it { should belong_to(:bank_account) }
  it { should validate_presence_of(:trade_type) }
  it { should validate_presence_of(:account_id) }
  it { should validate_presence_of(:symbol) }
  it { should validate_presence_of(:shares) }
  it { should validate_presence_of(:price) }
end
