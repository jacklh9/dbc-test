class RenameItemTableColumnsStartEnd < ActiveRecord::Migration
  def change
  	rename_column(:items, :start, :auction_start)
  	rename_column(:items, :end, :auction_end)
  end
end
