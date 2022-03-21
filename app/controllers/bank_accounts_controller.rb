class BankAccountsController < ApplicationController
  layout 'base'

  def index
    @bank_accounts = BankAccount.where(id: current_user.bank_account_ids)
                                .paginate(page: params[:page], per_page: 10)
                                .order(:created_at)
  end
end
