class CreateTotalRanks < ActiveRecord::Migration
  def change
    create_table :total_ranks do |t|
      t.integer :category
      t.integer :sub_category
      t.string :players, :default => ''
      t.string :values, :default => ''
      t.timestamps
    end
  end
end
