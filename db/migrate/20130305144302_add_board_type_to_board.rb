class AddBoardTypeToBoard < ActiveRecord::Migration
  def self.up
    add_column :boards, :board_type, :integer, :default => 0
  end

  def self.down
    remove_column :boards, :board_type
  end
end
