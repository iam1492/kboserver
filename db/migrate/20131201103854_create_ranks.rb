class CreateRanks < ActiveRecord::Migration
  def change
    create_table :ranks do |t|
      t.string :rank
      t.string :team
      t.string :game_count
      t.string :win
      t.string :defeat
      t.string :draw
      t.string :win_rate
      t.string :win_diff
      t.string :continue
      t.string :recent_game
      t.timestamps
    end
  end
end
