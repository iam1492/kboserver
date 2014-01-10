class Schedule < ActiveRecord::Base
  attr_accessible :day, :weak, :home_team, :home_score, :away_score, :away_team, :start_time, :tv_info, :station, :no_match
end
