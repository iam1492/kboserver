class AddNickNameToComment < ActiveRecord::Migration
  def change
  	add_column :comments, :nickname, :string, :null=>false, :default => ""
  end
end
