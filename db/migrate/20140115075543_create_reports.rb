class CreateReports < ActiveRecord::Migration
  def change
    create_table :reports do |t|
      t.string :title
      t.text :description
      t.string :thumbnail_url
      t.string :url
      t.datetime :pub_date
      t.timestamps
    end
  end
end
