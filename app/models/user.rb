class User < ActiveRecord::Base
  attr_accessible :blocked, :imei, :nick_count, :nickname, :user_type, :alerter_count, :alerters_count #:cached_votes_down
  acts_as_api
  acts_as_voter
  #acts_as_votable

  has_many :relationships, foreign_key: "alerter_id", dependent: :destroy
  has_many :alerted_users, through: :relationships, source: :alerted
  has_many :reverse_relationships, foreign_key: "alerted_id",
                                   class_name: "Relationship",
                                   dependent: :destroy
  has_many :alerters, through: :reverse_relationships, source: :alerter

  api_accessible :render_users do |t|
    t.add :imei
  	t.add :nickname
  	t.add :blocked
  	t.add :nick_count
    t.add :alerters_count
  	t.add :user_type
  end

  def alert!(other_user)
    relationships.create!(alerted_id: other_user.id)
  end

  def has_alerted?(other_user)  
    if relationships.find_by_alerted_id(other_user.id).nil?
      false
    else
      true
    end
  end

  def self.getUserInfo(_imei)
  	where("imei = ?", _imei).first
  end

  def self.getUserInfoByNickname(_nickname)
    where("nickname = ?", _nickname).first
  end

  def self.uniqueNickname?(_nickname)
    nickname = where("nickname = ?", _nickname).first
    if (nickname.nil?)
      return true
    else
      return false
    end
  end

  # def alerts_count
  #   self.cached_votes_down
  # end

  def self.getBlockedUsers
    where("blocked = ?", true).order('cached_votes_down desc')
  end

  def self.getHighAlertUsers
    order("cached_votes_down desc").limit(50)
  end
end
