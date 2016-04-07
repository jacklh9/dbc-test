class CreateItemsTable < ActiveRecord::Migration
  def change
  	create_table :items do |t|
  		t.string	:name_title, null: false
  		t.integer	:condition_id, null: false
  		t.decimal	:price, null: false
  		t.datetime	:start, null: false
  		t.datetime	:end, null: false
  		t.text		:description, null: false
  		t.integer	:user_id, null: false
  		t.timestamps	null: false
  	end
  end
end
