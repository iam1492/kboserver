class Reply < ActiveRecord::Base
  attr_protected :id
  attr_accessible :content, :board_id, :imei, :created_at
  belongs_to :board

  validate :content, presence: true, length: { maximum: 255 }
  validate :board_id, presence: true

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
    logger.debug @user
    if (@user.nil?)
      @user = User.getUserInfo(self.imei);
    end
    
    if (@user.nil?)
      return ""
    end

    @user.profile_thumbnail_path
  end

  def as_json options=nil
    options ||= {}
    options[:methods] = ((options[:methods] || []) + 
           [:nickname, :profile_thumbnail_url])
    super options
  end
end
