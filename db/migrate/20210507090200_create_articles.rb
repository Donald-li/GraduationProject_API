class CreateArticles < ActiveRecord::Migration[6.1]
  def change
    create_table :articles do |t|
      t.text :title
      t.text :body
      t.float :score
      t.integer :section
      t.integer :thumbs

      t.timestamps
    end
  end
end
