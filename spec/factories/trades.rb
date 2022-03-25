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
#  job_id     :string
#
# Foreign Keys
#
#  fk_rails_...  (account_id => bank_accounts.id) ON DELETE => nullify
#  fk_rails_...  (trade_type => trade_types.name) ON DELETE => nullify
#
FactoryBot.define do
  factory :trade do
    trade_type { 'buy' }
    account_id { FactoryBot.create(:bank_account).id }
    symbol { FFaker::Company.name }
    shares { 1 }
    price { 1.5 }
    timestamp { 10.minutes.ago.to_s(:db) }
    job_id { nil }
  end
end
