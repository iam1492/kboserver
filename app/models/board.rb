class Board < ActiveRecord::Base
  attr_accessible :title, :content, :imei, :id ,:photo, :board_type
  has_attached_file :photo, :styles => { :original => "720x", :medium => "320x", :thumb => "100x100>" }

  self.per_page = 20
  acts_as_api
  acts_as_votable
  has_many :replies, dependent: :destroy
  
  validates :title, presence: true
  validates :content, presence: true
  validates :imei, presence: true

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
  end

  def is_voted
    if (self.imei.nil?)
      return false
    end
    
    @user = User.cachedUserInfo(self.imei)
    if (@user.nil?)
      @user = User.getUserInfo(self.imei);
    end
    
    if (@user.nil?)
      return false
    end

    @user.voted_up_on?(self)
  end

  def total_replies
    self.replies.count
  end

  def nickname
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

  	@user.nickname
  end

  def profile_thumbnail_url
    
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

    @user.profile_thumbnail_path
  end

  def likes_count
    self.cached_votes_up
  end

  def photo_path
  	if (self.photo.nil?)
  		return nil
  	end
  	self.photo.url
  end

  def photo_thumbnail_path
  	if (self.photo.nil?)
  		return nil
  	end
  	self.photo.url(:thumb)
  end

  def photo_medium_path
  	if (self.photo.nil?)
  		return nil
  	end
  	self.photo.url(:medium)  	
  end
end