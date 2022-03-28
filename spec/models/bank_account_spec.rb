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
require 'rails_helper'

RSpec.describe BankAccount, type: :model do
  it { should belong_to(:user) }
  it { should have_many(:trades) }
  it { should validate_presence_of(:amount) }
end
