class CreateJokesTable < ActiveRecord::Migration
  def change
    create_table :jokes do |t|
      t.text :content, null: false
      t.timestamps  null: false
    end
  end
end
