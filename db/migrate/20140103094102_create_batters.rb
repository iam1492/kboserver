class CreateBatters < ActiveRecord::Migration
  def change
    create_table :batters do |t|
      t.string :rank
      t.string :player
      t.string :team
      t.string :game_count
      t.string :play_count
      t.string :bat_count
      t.string :hit
      t.string :b2
      t.string :b3
      t.string :hr
      t.string :hit_score
      t.string :own_score
      t.string :stolen_base
      t.string :dead_ball
      t.string :out_count
      t.string :heat_rate
      t.string :run_rate
      t.string :long_rate
      t.string :ops
      t.timestamps
    end
  end
end
