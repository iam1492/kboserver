class AddCachedVotesToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :cached_votes_total, :integer, :default => 0
    add_column :users, :cached_votes_score, :integer, :default => 0
    add_column :users, :cached_votes_up, :integer, :default => 0
    add_column :users, :cached_votes_down, :integer, :default => 0
    add_index  :users, :cached_votes_total
    add_index  :users, :cached_votes_score
    add_index  :users, :cached_votes_up
    add_index  :users, :cached_votes_down
  end

  def self.down
    remove_column :users, :cached_votes_total
    remove_column :users, :cached_votes_score
    remove_column :users, :cached_votes_up
    remove_column :users, :cached_votes_down
  end
end
