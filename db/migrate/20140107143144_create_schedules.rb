class CreateSchedules < ActiveRecord::Migration
  def change
    create_table :schedules do |t|
      t.string :day
      t.string :weak
      t.string :home_team
      t.string :home_score
      t.string :away_score
      t.string :away_team
      t.string :start_time
      t.string :tv_info
      t.string :station
      t.boolean :no_match
      t.timestamps
    end
  end
end
