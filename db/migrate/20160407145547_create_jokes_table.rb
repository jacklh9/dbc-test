class CreateJokesTable < ActiveRecord::Migration
  def change
    create_table :jokes do |t|
      t.text 		:content, null: false
      t.integer 	:joke_hash, null: false
      t.timestamps  null: false
    end
    add_index :jokes, :joke_hash, unique: true
  end
end
