class Reply < ActiveRecord::Base
  attr_accessible :content, :board_id, :imei, :created_at
  belongs_to :board

  validate :content, presence: true, length: { maximum: 255 }
  validate :board_id, presence: true

  def nickname
  	if (self.imei.nil?)
  		"not valid user"
  		return
  	end
  	@user = User.getUserInfo(self.imei);
  	@user.nickname
  end

  def profile_thumbnail_url
    @user = User.getUserInfo(self.imei)
    if (@user.profile.nil?)
      return nil
    end
    @user.profile.url(:thumb)
  end

  def as_json options=nil
    options ||= {}
    options[:methods] = ((options[:methods] || []) + 
           [:nickname, :profile_thumbnail_url])
    super options
  end
end
