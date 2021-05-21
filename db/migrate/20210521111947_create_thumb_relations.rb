class CreateThumbRelations < ActiveRecord::Migration[6.1]
  def change
    create_table :thumb_relations do |t|
      t.references :user, null: false, foreign_key: true
      t.references :article, null: false, foreign_key: true

      t.timestamps
    end
  end
end
