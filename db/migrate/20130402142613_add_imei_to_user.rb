class AddImeiToUser < ActiveRecord::Migration
  def change
  	add_column :comments, :imei, :string, :default => ""
  end
end
