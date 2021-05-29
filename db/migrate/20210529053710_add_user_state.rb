class AddUserState < ActiveRecord::Migration[6.1]
  change_table :users do |t|
    t.integer :state
  end
end
