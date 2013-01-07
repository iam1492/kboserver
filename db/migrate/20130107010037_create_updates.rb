class CreateUpdates < ActiveRecord::Migration
  def change
    create_table :updates do |t|
      t.string :content
      t.integer :version
      t.string :extra

      t.timestamps
    end
  end
end
