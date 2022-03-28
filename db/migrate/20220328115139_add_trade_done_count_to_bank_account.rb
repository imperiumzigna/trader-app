class AddTradeDoneCountToBankAccount < ActiveRecord::Migration[5.2]
  def change
    add_column :bank_accounts, :trades_done_count, :integer, null: false, default: 0
  end
end
