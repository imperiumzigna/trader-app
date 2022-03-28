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
require 'aasm'

class Trade < ApplicationRecord
  include AASM

  belongs_to :bank_account, foreign_key: :account_id

  counter_culture :bank_account, column_name: proc {|trade| trade.done? ? 'trades_done_count' : nil },
  column_names: {
    ['trades.state = ?', 'done'] => 'trades_done_count'
  }

  validates_presence_of :trade_type, :account_id, :symbol, :shares, :price
  validates_inclusion_of :shares, in: 1..100
  validates_numericality_of :price, greater_than: 0

  aasm :state do
    state :pending, initial: true
    state :done
    state :canceled

    event :process do
      transitions from: :pending, to: :done
    end

    event :cancel do
      transitions from: :pending, to: :canceled
    end
  end

  def total_price
    price * shares
  end
end
