class ChangeRuleFun < ActiveRecord::Migration[6.1]
  change_table :articles do |t|
    t.integer :state
  end

  change_table :comments do |t|
    t.integer :state
  end

  change_table :messages do |t|
    t.integer :state
  end
end
