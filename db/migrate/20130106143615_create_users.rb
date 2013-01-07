class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :nickname,        :null => false, :default => ""
      t.string :imei,            :null => false, :default => ""
      t.boolean :blocked,        :default => false
      t.integer :alert_count,    :default => 0
      t.integer :nick_count,     :default => 0
      t.integer :user_type,      :default => 0

      t.timestamps
    end

    add_index :users, :imei, :unique => true
    add_index :users, :nickname, :unique => true
  end
end
