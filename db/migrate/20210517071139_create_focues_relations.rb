class CreateFocuesRelations < ActiveRecord::Migration[6.1]
  def change
    create_table :focues_relations do |t|
      t.references :user
      t.references :follower

      t.timestamps
    end
  end
end
