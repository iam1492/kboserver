class Rank < ActiveRecord::Base
  attr_accessible :rank, :team, :game_count, :win, :defeat, :draw, :win_rate, :win_diff, :win_continue, :recent_game
end
