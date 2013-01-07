class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.string :comment,        :null => false, :default => ""
      t.integer :team_idx,      :null => false
      t.integer :out_count,     :default => -1
      t.integer :strike,        :default => -1
      t.integer :ball,          :default => -1
      t.string :base,           :default => ""
      t.string :stage,          :default => ""
      t.string :game_id,        :default => ""
      t.string :type,           :default => ""
      t.string :extra_1
      t.string :extra_2

      t.timestamps
    end

    add_index :comments, :game_id,                 :unique => false
  end
end
