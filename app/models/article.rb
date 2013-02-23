class Article < ActiveRecord::Base
  attr_accessible :article_url, :nickname, :title, :cached_votes_up, :alert_count, :created_at

  acts_as_api
  acts_as_votable

  def self.getMoreArticles(_id, _max)
    where("id < ?",_id).limit(_max).order('id desc')
  end

  def self.getFirstArticles(_max)
    limit(_max).order('id desc')
  end

  def self.getMoreArticlesByLike(vote_count, _id, _max)
    where("cached_votes_up < ? AND id !=  ?",vote_count, _id).limit(_max).order('cached_votes_up desc')
  end

  def self.getFirstArticlesByLike(_max)
    limit(_max).order('cached_votes_up desc')
  end

  api_accessible :render_articles do |t|
    t.add :id
  	t.add :nickname
  	t.add :article_url
  	t.add :title
    t.add :alert_count
    t.add :likes_count
    t.add :created_at
  end

  def likes_count
    self.cached_votes_up
  end

end
