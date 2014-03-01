class AddAndRemoveColumnToTotalRank < ActiveRecord::Migration
  def change
    add_column :total_ranks, :profile_img, :string, :default => ''
    remove_column :total_ranks, :sub_category
  end
end
