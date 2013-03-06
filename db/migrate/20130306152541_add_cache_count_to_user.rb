class AddCacheCountToUser < ActiveRecord::Migration
  def self.up
  	add_column :users, :alerters_count, :integer, :default => 0

	User.reset_column_information

	User.all.each do |user|
	  User.update_counters(user.id, :alerters_count => user.alerters.length)
	end
  end

  def self.down
  	remove_column :users, :alerters_count
  end
end
