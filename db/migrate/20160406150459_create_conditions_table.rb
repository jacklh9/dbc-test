class CreateConditionsTable < ActiveRecord::Migration
  def change
  	create_table :conditions do |t|
  		t.string	:name, null: false
  		t.timestamps	null: false
  	end
  	add_index :conditions, :name, unique: true
  end
end
