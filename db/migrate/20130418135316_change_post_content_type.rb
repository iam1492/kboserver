class ChangePostContentType < ActiveRecord::Migration
  change_table :boards do |t|  
     t.change :content, :text
  end
end
