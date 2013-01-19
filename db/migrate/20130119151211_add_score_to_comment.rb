class AddScoreToComment < ActiveRecord::Migration
  def change
  	add_column :comments, :homescore, :integer, :default => 0
  	add_column :comments, :awayscore, :integer, :default => 0
  end
end
