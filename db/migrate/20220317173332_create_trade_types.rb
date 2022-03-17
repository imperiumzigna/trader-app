class CreateTradeTypes < ActiveRecord::Migration[5.2]
  def change
    create_table :trade_types, id: false do |t|
      t.string :name, null: false, index: true, unique: true, primary_key: true

      t.timestamps
    end
  end
end
