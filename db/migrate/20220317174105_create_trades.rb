class CreateTrades < ActiveRecord::Migration[5.2]
  def change
    create_table :trades do |t|
      t.string :trade_type, null: false
      t.integer :account_id, null: false
      t.string :symbol, null: false
      t.integer :shares, null: false
      t.float :price, null: false
      t.string :state, null: false
      t.integer :timestamp, null: false

      t.timestamps
    end
  end
end
