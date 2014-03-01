class CreateTotalHitterRanks < ActiveRecord::Migration
  def change
    create_table :total_hitter_ranks do |t|
      t.string :profile_img, :default => ''
      t.integer :category
      t.string :players, :default => ''
      t.string :values, :default => ''
      t.timestamps
    end
  end
end
