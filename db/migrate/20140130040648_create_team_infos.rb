class CreateTeamInfos < ActiveRecord::Migration
  def change
    create_table :team_infos do |t|
      t.integer :team_id
      t.integer :total_score, :default => ''
      t.integer :total_loss, :default => ''
      t.float :total_avg, :default => ''
      t.integer :total_hit, :default => ''
      t.integer :total_hr, :default => ''
      t.integer :total_rb, :default => ''
      t.integer :total_outcout, :default => ''
      t.integer :total_failure, :default => ''
      t.timestamps
    end
  end
end
