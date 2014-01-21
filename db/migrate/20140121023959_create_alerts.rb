class CreateAlerts < ActiveRecord::Migration
  def change
    create_table :alerts do |t|
      t.string :user_imei
      t.integer :board_id
      t.timestamps
    end

    add_index :alerts, :user_imei
    add_index :alerts, :board_id
    add_index :alerts, [:user_imei, :board_id], unique: true
  end
end
