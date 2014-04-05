class AddTeamIdToRank < ActiveRecord::Migration
  def change
    add_column :ranks, :team_id, :integer
  end
end
