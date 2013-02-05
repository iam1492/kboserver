class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.string :title
      t.string :nickname
      t.string :article_url

      t.timestamps
    end
  end
end
