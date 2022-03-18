class AddBankAccountToTrade < ActiveRecord::Migration[5.2]
  def up
    add_foreign_key :trades, :bank_accounts, column: :account_id, on_delete: :nullify
  end

  def down
    remove_foreign_key :trades, :bank_accounts
  end
end
