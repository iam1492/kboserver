class AddImeiToArticle < ActiveRecord::Migration
  def change
  	add_column :articles, :imei, :string, :default => ""
  end
end
