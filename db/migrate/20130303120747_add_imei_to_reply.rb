class AddImeiToReply < ActiveRecord::Migration
  def change
  	add_column :replies, :imei, :string
  end
end
