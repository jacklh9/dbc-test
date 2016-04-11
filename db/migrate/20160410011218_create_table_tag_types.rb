class CreateTableTagTypes < ActiveRecord::Migration
  def change
  	create_table :tag_types do |t|
  		t.string	:name, null: false
  		t.timestamps	null: false
  	end
  	add_column :tags, :tag_type_id, :integer, {default: 1, null: false}
  	TagType.create(id: 0, name: 'user_query')
  	TagType.create(id: 1, name: 'api_result')
  	Tag.all.each do |tag|
  		tag.tag_type = 'api_query'
  		tag.save
  	end
  end
end
