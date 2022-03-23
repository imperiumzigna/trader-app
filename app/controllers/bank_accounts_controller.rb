class BankAccountsController < ApplicationController
  layout 'base'

  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found

  def index
    @bank_accounts = BankAccountFilter.call(bank_account_ids: current_user.bank_account_ids,
                                            params: params).bank_accounts
  end

  def show
    @bank_account = BankAccount.find(params[:id])
  end

  private
    def render_not_found
      flash[:alert] = 'Bank account not found'

      redirect_to bank_accounts_path
    end
end
