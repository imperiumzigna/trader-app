require 'interactor'

class UserCreator
  include Interactor

  BANK_ACCOUNT_INITIAL_AMOUNT = 1000

  def self.call(user_params:)
    super
  end

  def call
    create_user
    setup_bank_account if context.user.persisted?
  end

  private
    def create_user
      user = User.new(context.user_params)

      user.save

      context.user = user
    end

    def setup_bank_account
      context.user.bank_accounts.create(amount: BANK_ACCOUNT_INITIAL_AMOUNT)
    end
end
