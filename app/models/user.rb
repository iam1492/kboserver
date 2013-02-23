class User < ActiveRecord::Base
  attr_accessible :cached_votes_down, :blocked, :imei, :nick_count, :nickname, :user_type
  acts_as_api
  acts_as_voter
  #acts_as_votable

  api_accessible :render_users do |t|
    t.add :imei
  	t.add :nickname
  	t.add :blocked
  	t.add :nick_count
  	t.add :alerts_count
  	t.add :user_type
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

  def alerts_count
    self.cached_votes_down
  end

  def self.getBlockedUsers
    where("blocked = ?", true).order('cached_votes_down desc')
  end

  def self.getHighAlertUsers
    order("cached_votes_down desc").limit(50)
  end
end
