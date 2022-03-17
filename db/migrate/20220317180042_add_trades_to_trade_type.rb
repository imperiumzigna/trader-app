class AddTradesToTradeType < ActiveRecord::Migration[5.2]
  def up
    add_foreign_key :trades, :trade_types, column: :trade_type, primary_key: :name, on_delete: :nullify
  end

  def down
    remove_foreign_key :trades, :trade_types
  end
end
