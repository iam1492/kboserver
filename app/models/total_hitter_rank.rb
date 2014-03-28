class TotalHitterRank < ActiveRecord::Base
  attr_protected :id

  after_commit :flush_cache

  def self.cached_total_hitters
    Rails.cache.fetch([self, 'total_hitters'], expires_in: 20.minutes) do
      TotalHitterRank.all.to_a
    end
  end

  def flush_cache
    Rails.cache.delete([self.class.name, 'total_hitters'])
  end
end
