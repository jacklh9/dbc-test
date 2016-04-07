class Bid < ActiveRecord::Base
  # Remember to create a migration!
  validates :bidder, :item, :price, presence: true

  validates :bidder, uniqueness: { scope: :item }

  belongs_to :bidder, class_name: :User
  belongs_to :item
  has_one :seller, through: :item

  def active?
  	now = DateTime.now
  	self.auction_start <= now && now < self.auction_end 
  end

end
