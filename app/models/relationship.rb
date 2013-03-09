class Relationship < ActiveRecord::Base
  attr_accessible :alerted_id

  belongs_to :alerter, :class_name => "User"
  belongs_to :alerted, :class_name => "User", :counter_cache => :alerters_count

  validates :alerter_id, presence: true
  validates :alerted_id, presence: true
end