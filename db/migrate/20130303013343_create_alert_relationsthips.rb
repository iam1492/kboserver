class CreateAlertRelationsthips < ActiveRecord::Migration
  def change
    create_table :relationships do |t|
      t.integer :alerter_id
      t.integer :alerted_id

      t.timestamps
    end

    add_index :relationships, :alerter_id
    add_index :relationships, :alerted_id
    add_index :relationships, [:alerter_id, :alerted_id], unique: true
  end
end
