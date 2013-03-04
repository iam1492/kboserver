class Board < ActiveRecord::Base
  attr_accessible :title, :content, :imei, :id ,:photo
  has_attached_file :photo, :styles => { :medium => "720x", :thumb => "100x100>" }

  self.per_page = 10
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
    #t.add :replies
    t.add :nickname
    t.add :imei
    t.add :created_at
    t.add :likes_count
    t.add :photo_path
    t.add :photo_thumbnail_path
    t.add :photo_medium_path
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
  end

  def total_replies
    self.replies.count
  end

  def nickname
  	@user = User.getUserInfo(self.imei)
  	@user.nickname
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