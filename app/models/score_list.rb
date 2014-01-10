class ScoreList < ActiveRecord::Base
  attr_accessible :status, :home_team, :home_score, :away_team, :away_score, :station, :start_time, :link
end
