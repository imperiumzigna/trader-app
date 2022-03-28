# == Schema Information
#
# Table name: bank_accounts
#
#  id                :bigint           not null, primary key
#  amount            :float
#  trades_done_count :integer          default(0), not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  user_id           :bigint
#
# Indexes
#
#  index_bank_accounts_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
FactoryBot.define do
  factory :bank_account do
    user { FactoryBot.create(:user) }
    amount { 1000 }
  end
end
