class TotalRank < ActiveRecord::Base
  attr_protected :id

  after_commit :flush_cache

  def self.cached_total
    Rails.cache.fetch([self, 'total'], expires_in: 20.minutes) do
      TotalRank.all.to_a
    end
  end

  def flush_cache
    Rails.cache.delete([self.class.name, 'total'])
  end
end
