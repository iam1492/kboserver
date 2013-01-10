class AddIsBroadcastToComment < ActiveRecord::Migration
  def change
  	add_column :comments, :is_broadcast, :boolean, :null=>false, :default => false
  end
end
