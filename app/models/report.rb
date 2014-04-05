class Report < ActiveRecord::Base
  attr_protected :id
  after_commit :flush_cache

  self.per_page = 10

  def self.update_from_feed(feed_url)
    feed = Feedzirra::Feed.fetch_and_parse(feed_url)
    feed.entries.each do |item|
      unless Report.exists? :url => item.url
        puts 'item: %s' % item.title
        feed = Report.create!(:title => item.title,:description => item.summary,:thumbnail_url => item.image,
                        :url => item.url,:pub_date => item.published)

      end
    end
  end

  def self.cached_rank
    Rails.cache.fetch([self, 'first_report'], expires_in: 20.minutes) do
      Report.all.page(1).order('pub_date DESC')
    end
  end

  def self.cached_rank_2
    Rails.cache.fetch([self, 'first_report_2'], expires_in: 20.minutes) do
      Report.all.page(2).order('pub_date DESC')
    end
  end

  def flush_cache
    Rails.cache.delete([self.class.name, 'first_report'])
    Rails.cache.delete([self.class.name, 'first_report_2'])
  end
end