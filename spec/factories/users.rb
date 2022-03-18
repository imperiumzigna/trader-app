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
FactoryBot.define do
  factory :user do
    name { FFaker::Name.name }
    surname { FFaker::Name.last_name }
    email { FFaker::Internet.email }
    password { 'password' }
    password_confirmation { 'password' }
    active { true }

    after(:create) do |user|
      create_list(:bank_account, 2, user: user, amount: 1000)
    end
  end
end
