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
require 'aasm'

class Trade < ApplicationRecord
  include AASM

  belongs_to :bank_account, foreign_key: :account_id

  validates_presence_of :trade_type, :account_id, :symbol, :shares, :price

  aasm :state do
    state :pending, initial: true
    state :done
    state :canceled

    event :proccess do
      transitions from: :pending, to: :done
    end

    event :cancel do
      transitions from: :pending, to: :canceled
    end
  end
end
