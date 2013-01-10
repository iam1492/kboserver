class RenameCommentType < ActiveRecord::Migration
  def change
  	change_table :comments do |t|
  		t.rename :type, :comment_type
  	end
  end
end
