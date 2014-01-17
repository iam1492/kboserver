class Report < ActiveRecord::Base
  attr_protected :id

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
end