require 'interactor'

class BankAccountFilter
  include Interactor

  delegate :params, to: :context

  def self.call(bank_account_ids:, params:)
    super
  end

  def call
    bank_accounts = BankAccount.where(id: account_ids)

    context.bank_accounts = bank_accounts.paginate(page: params[:page], per_page: 10).order(:created_at)
  end

  private
    def account_ids
      params[:search].present? ? params[:search] : context.bank_account_ids
    end
end
