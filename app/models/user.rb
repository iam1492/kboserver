class User < ActiveRecord::Base
  attr_accessible :alert_count, :blocked, :imei, :nick_count, :nickname, :user_type
  acts_as_api

  api_accessible :render_users do |t|
    t.add :imei
  	t.add :nickname
  	t.add :blocked
  	t.add :nick_count
  	t.add :alert_count
  	t.add :user_type
  end

  def self.getUserInfo(_imei)
  	where("imei = ?", _imei).first
  end

  def self.getBlockedUsers
    where("blocked = ?", true).order('alert_count desc')
  end

  def self.getHighAlertUsers
    order("alert_count desc").limit(50)
  end

end
