class Alert < ActiveRecord::Base
  attr_accessible :user_imei, :board_id
  belongs_to :user, foreign_key: :user_imei
  belongs_to :board
end
