class Item < ActiveRecord::Base
  # Remember to create a migration!

  validates :name_title, :condition, :price, :auction_start, :auction_end, :description, :seller, presence: true

  belongs_to :seller, class_name: :User
  belongs_to :condition
  has_many :bids
  has_many :bidders, through: :bids

  def is_bidder?(user)
  	bidders.include? user
  end

  def highest_bid
  	self.bids.order(price: :desc).first
  end

end
