class Comment < ActiveRecord::Base
  attr_accessible :ball, :base, :comment, :extra_1, :extra_2,
  				  :game_id, :out_count, :stage, :strike, :team_idx,
  				  :comment_type, :created_at, :nickname, :id

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
  end
end
