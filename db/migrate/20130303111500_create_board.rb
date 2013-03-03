class CreateBoard < ActiveRecord::Migration
  def change
    create_table :boards do |t|
      t.string :title
      t.string :content
      t.string :imei

      t.timestamps
    end

    add_index :boards, :imei
  end
end
