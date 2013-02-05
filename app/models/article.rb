class Article < ActiveRecord::Base
  attr_accessible :article_url, :nickname, :title

  acts_as_api

  def self.getMoreArticles(_id, _max)
    where("id < ?",_id).limit(_max).order('id desc')
  end

  def self.getFirstArticles(_max)
    limit(_max).order('id desc')
  end

  api_accessible :render_articles do |t|
    t.add :id
  	t.add :nickname
  	t.add :article_url
  	t.add :title
    t.add :created_at
  end
end
