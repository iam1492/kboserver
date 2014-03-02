class CreatePitchers < ActiveRecord::Migration
  def change
    create_table :pitchers do |t|
      t.string :rank
      t.string :player
      t.string :team
      t.string :game_count
      t.string :win
      t.string :lose
      t.string :save
      t.string :hold
      t.string :inning
      t.string :ball_count
      t.string :hit_count
      t.string :hr_count
      t.string :out_count
      t.string :dead_ball
      t.string :total_lost_score
      t.string :lost_score
      t.string :avg_lost_score
      t.string :whip
      t.string :qs
      t.timestamps
    end
  end
end
