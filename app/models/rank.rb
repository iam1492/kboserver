class Rank < ActiveRecord::Base
  attr_accessible :rank, :team, :game_count, :win, :defeat, :draw, :win_rate, :win_diff, :win_continue, :recent_game, :team_id
  after_commit :flush_cache

  def self.cached_rank
    Rails.cache.fetch([self, 'rank_new'], expires_in: 20.minutes) do
      Rank.all.order('rank ASC')
    end
  end

  def flush_cache
    Rails.cache.delete([self.class.name, 'ranks'])
  end
end
