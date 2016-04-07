class CreateTagsTable < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.integer :user_id
      t.string :name, null: false
      t.timestamps  null: false
    end
      add_index :tags, [:user_id, :name], :unique => true
    end
end
