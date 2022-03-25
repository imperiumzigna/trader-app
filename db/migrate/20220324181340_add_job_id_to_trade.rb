class AddJobIdToTrade < ActiveRecord::Migration[5.2]
  def change
    add_column :trades, :job_id, :string, null: true
  end
end
