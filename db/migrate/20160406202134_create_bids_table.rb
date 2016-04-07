class CreateBidsTable < ActiveRecord::Migration
  def change
  	create_table :bids do |t|
  		t.integer :bidder_id, null: false
  		t.integer :item_id, null: false
  		t.decimal :price, null: false
  		t.timestamps	null: false
  	end
  	add_index :bids, [:bidder_id, :item_id], unique: true
  end
end
