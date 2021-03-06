# == Schema Information
#
# Table name: bank_accounts
#
#  id         :bigint           not null, primary key
#  amount     :float
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint
#
# Indexes
#
#  index_bank_accounts_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class BankAccount < ApplicationRecord
  belongs_to :user
  has_many :trades, dependent: :destroy, foreign_key: :account_id

  validates_presence_of :amount, :user_id
  validates_numericality_of :amount, greater_than_or_equal_to: 0.0
end
