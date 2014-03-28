class Batter < ActiveRecord::Base
  attr_accessible :rank, :player, :team, :game_count, :play_count, :bat_count, :hit, :b2, :b3, :hr, :hit_score, :own_score, :stolen_base, :dead_ball, :out_count, :heat_rate, :run_rate, :long_rate, :ops

  after_commit :flush_cache

  def self.cached_batters
    Rails.cache.fetch([self, 'batters'], expires_in: 20.minutes) do
      Batter.all.to_a
    end
  end

  def flush_cache
    Rails.cache.delete([self.class.name, 'batters'])
  end
end
