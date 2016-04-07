class CreateJokeTagsTable < ActiveRecord::Migration
  def change
    create_table :joke_tags do |t|
      t.integer :user_id
      t.integer :joke_id, null: false
      t.integer :tag_id, null: false
      t.timestamps  null: false
    end
    add_index :user_joke_tags, [:user_id, :joke_id, :tag_id], :unique => true
  end
end
