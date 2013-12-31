class CreateTotalRanks < ActiveRecord::Migration
  def change
    create_table :total_ranks do |t|
      t.integer :rank_type
      t.integer :rank
      t.string :name
      t.string :team
      t.string :number
      t.string :profile_image_url
      t.timestamps
    end
  end
end
