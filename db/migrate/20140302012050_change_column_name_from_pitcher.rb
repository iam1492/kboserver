class ChangeColumnNameFromPitcher < ActiveRecord::Migration
  def self.up
    rename_column :pitchers, :save, :save_point
  end

  def self.down
    rename_column :pitchers, :save, :save_point
  end
end
