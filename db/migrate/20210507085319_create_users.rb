class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.text :account
      t.text :name
      t.text :password
      t.integer :rule
      t.text :img
      # t.references :article, null: false, foreign_key: true

      t.timestamps
    end
  end
end
