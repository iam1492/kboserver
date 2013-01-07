class Update < ActiveRecord::Base
  attr_accessible :content, :extra, :version
  acts_as_api

  def self.getLastUpdate
  	Update.order("created_at desc").first
  end

  api_accessible :render_update do |t|
  	t.add :content
  	t.add :version
  end

end
