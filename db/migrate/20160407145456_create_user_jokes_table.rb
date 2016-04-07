class CreateUserJokesTable < ActiveRecord::Migration
  def change
    create_table :user_jokes do |t|
      t.integer :user_id, null: false
      t.integer :joke_id, null: false
      t.timestamps  null: false
    end
    add_index :user_jokes, [:user_id, :joke_id], :unique => true
  end
end
