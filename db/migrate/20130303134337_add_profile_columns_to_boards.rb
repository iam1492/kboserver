class AddProfileColumnsToBoards < ActiveRecord::Migration
  def self.up
    add_attachment :boards, :photo
  end

  def self.down
    remove_attachment :boards, :photo
  end
end
