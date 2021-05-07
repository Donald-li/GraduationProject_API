class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.text :account
      t.text :name
      t.text :password
      t.integer :rule
      t.text :img

      t.timestamps
    end
  end
end
