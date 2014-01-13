class ChangeColumnName < ActiveRecord::Migration

  def self.up
    rename_column :ranks, :continue, :win_continue
  end

  def self.down
    rename_column :ranks, :win_continue, :continue
  end
end
