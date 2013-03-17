class AddProfileToUser < ActiveRecord::Migration
  def self.up
  	add_column :users, :intro, :string, :default => ""
    add_attachment :users, :profile
  end

  def self.down
  	remove_column :users, :intro
    remove_attachment :users, :profile
  end
end
