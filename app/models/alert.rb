class Alert < ActiveRecord::Base
  attr_accessible :user_imei, :board_id
  belongs_to :user
  belongs_to :board
end
