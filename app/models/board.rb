class Board < ActiveRecord::Base
  attr_protected :id
  attr_accessible :title, :content, :imei, :id, :photo, :board_type, :cached_votes_total, :cached_votes_up, :cached_votes_down, :cached_votes_score
  has_attached_file :photo, :styles => { :original => "720x", :medium => "320x", :thumb => "100x100>" }

  self.per_page = 20
  acts_as_api
  acts_as_votable
  has_many :replies, dependent: :destroy, :order => "created_at ASC"
  has_many :alerts, dependent: :destroy
  has_many :users, :through => :alerts

  validates :title, presence: true
  validates :content, presence: true
  validates :imei, presence: true

  api_accessible :board_for_dev do |t| 
    t.add :id
    t.add :title
    t.add :nickname
    t.add :imei
  end

  api_accessible :board_without_replies do |t| 
  	t.add :id
  	t.add :title
  	t.add :content
  	t.add :total_replies
    t.add :nickname
    t.add :imei
    t.add :created_at
    t.add :likes_count    
    t.add :photo_path
    t.add :photo_thumbnail_path
    t.add :photo_medium_path
    t.add :board_type
    t.add :is_voted
    t.add :profile_thumbnail_url
    t.add :userProfile
    t.add :alert_count
  end

  api_accessible :board_with_replies do |t| 
    t.add :id
    t.add :title
    t.add :content
    t.add :total_replies
    t.add :replies
    t.add :nickname
    t.add :imei
    t.add :created_at
    t.add :likes_count    
    t.add :photo_path
    t.add :photo_thumbnail_path
    t.add :photo_medium_path
    t.add :board_type
    t.add :is_voted
    t.add :profile_thumbnail_url
    t.add :userProfile
    t.add :alert_count
  end

  def is_voted
    if (self.imei.nil?)
      return false
    end
    
    user = User.cachedUserInfo(self.imei)
    if (user.nil?)
      user = User.getUserInfo(self.imei);
    end
    
    if (user.nil?)
      return false
    end

    user.voted_up_on?(self)
  end

  def total_replies
    self.replies.count
  end

  def nickname
  	if self.imei.nil?
      return ''
    end
    
    user = User.cachedUserInfo(self.imei)
    if user.nil?
      user = User.getUserInfo(self.imei)
    end
    
    if user.nil?
      return ''
    end

  	user.nickname
  end

  def userProfile
    
    if (self.imei.nil?)
      return ""
    end
    
    @user = User.cachedUserInfo(self.imei)
    if (@user.nil?)
      @user = User.getUserInfo(self.imei);
    end
    
    if (@user.nil?)
      return ""
    end

    @user.profile_path
  end

  def profile_thumbnail_url
    
    if (self.imei.nil?)
      return ''
    end
    
    user = User.cachedUserInfo(self.imei)
    if user.nil?
      user = User.getUserInfo(self.imei);
    end
    
    if user.nil?
      return ''
    end

    user.profile_thumbnail_path
  end

  def likes_count
    self.cached_votes_up
  end

  def photo_path
  	if self.photo.nil?
  		return nil
  	end
  	self.photo.url
  end

  def photo_thumbnail_path
  	if self.photo.nil?
  		return nil
  	end
  	self.photo.url(:thumb)
  end

  def photo_medium_path
  	if self.photo.nil?
  		return nil
  	end
  	self.photo.url(:medium)  	
  end

  def alerting? (imei)
    alerts.find_by_user_imei(imei)
  end

  def alert_count
    self.alerts.all.length
  end

  def alert! (imei)
    alerts.create!(user_imei: imei)
    savedAlerts = self.alerts
    if savedAlerts.length >= 10
      self.destroy!
    end
  end

end