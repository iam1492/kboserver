class Pitcher < ActiveRecord::Base
  attr_protected :id

  after_commit :flush_cache

  def self.cached_pitchers
    Rails.cache.fetch([self, 'pitchers'], expires_in: 20.minutes) do
      Pitcher.all.to_a
    end
  end

  def flush_cache
    Rails.cache.delete([self.class.name, 'pitchers'])
  end
end
