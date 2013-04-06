class Comment < ActiveRecord::Base
  attr_accessible :ball, :base, :comment, :extra_1, :extra_2,
  				  :game_id, :out_count, :stage, :strike, :team_idx,
  				  :comment_type, :created_at, :nickname, :id, :is_broadcast,
            :homescore, :awayscore, :imei

  acts_as_api

  def self.getComments(_game_id, _id, _max)
    where("game_id = ? AND id > ?", _game_id, _id).limit(_max).order('id desc')
  end

  def self.getFirstComments(_game_id, _max)
    where("game_id = ?", _game_id).limit(_max).order('id desc')
  end

  def self.getMoreComments(_createdAt, _teamIdx)
    where("created_at > ? AND team_idx = ?", _createdAt, _teamIdx)
  end

  api_accessible :render_comments do |t|
    t.add :id
  	t.add :nickname
  	t.add :ball
  	t.add :base
  	t.add :comment
  	t.add :game_id
  	t.add :out_count
  	t.add :stage
  	t.add :strike
  	t.add :team_idx
  	t.add :comment_type
    t.add :created_at
    t.add :is_broadcast
    t.add :homescore
    t.add :awayscore
    t.add :userProfileThumbnail
    t.add :imei
  end

  def userProfileThumbnail
    
    if (self.imei.nil?)
      return ""
    end
    
    @user = User.getUserInfo(self.imei);
    
    if (@user.nil?)
      return ""
    end

    @user.profile_thumbnail_path
  end
end
