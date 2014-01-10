class CreateScoreLists < ActiveRecord::Migration
  def change
    create_table :score_lists do |t|
      t.string :status
      t.string :home_team
      t.string :home_score
      t.string :away_team
      t.string :away_score
      t.string :station
      t.string :start_time
      t.string :link
      t.timestamps
    end
  end
end
