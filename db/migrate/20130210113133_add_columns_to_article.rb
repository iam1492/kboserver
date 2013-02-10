class AddColumnsToArticle < ActiveRecord::Migration
  def change
  	add_column :articles, :like, :integer, :default => 0
  	add_column :articles, :alert_count, :integer, :default => 0
  end
end
