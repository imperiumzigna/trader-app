# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  active                 :boolean          default(FALSE)
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  name                   :string           not null
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  surname                :string           not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:surname) }
  it { should validate_presence_of(:email) }

  it { should have_many(:bank_accounts) }
  it { should have_many(:trades).through(:bank_accounts) }

  context '.password' do
    let(:user) { FactoryBot.build(:user) }
    let(:valid_password) { 'Password11*' }
    let(:invalid_password) { 'Password' }

    it 'returns valid user' do
      user.password = valid_password
      user.password_confirmation = valid_password

      expect(user).to be_valid
    end

    it 'returns errors with invalid format' do
      user.password = invalid_password
      user.password_confirmation = invalid_password

      expect(user).to_not be_valid
      expect(user.errors.full_messages).to include('Password Complexity requirement not met. Length should be 8-128 characters and include: 1 uppercase, 1 lowercase, 1 number and 1 special character')
    end
  end
end
