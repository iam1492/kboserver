class AddColoumnToSchedule < ActiveRecord::Migration
  def change
    add_column :schedules, :game_record_url, :string, :default => ""
    add_column :schedules, :game_relay_url, :string, :default => ""
    add_column :schedules, :is_canceled, :boolean, :default => false
  end
end
