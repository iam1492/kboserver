class CreateReplies < ActiveRecord::Migration
  def change
    create_table :replies do |t|
    	t.string :content
      	t.integer :board_id
      	t.timestamps
    end
  end
end
