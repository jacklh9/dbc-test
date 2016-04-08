class AddColumnJokeHashToJokesTable < ActiveRecord::Migration
  def change
  	add_column :jokes, :joke_hash, :integer, null: false
  end
end
