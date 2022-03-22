class BankAccountsController < ApplicationController
  layout 'base'

  def index
    @bank_accounts = BankAccountFilter.call(bank_account_ids: current_user.bank_account_ids,
                                            params: params).bank_accounts
  end
end
