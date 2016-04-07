class User < ActiveRecord::Base
  # Remember to create a migration!

  validates :name, presence: true
  validates :email, {presence: true, uniqueness: true}
  validates :password_hash, presence: true

  has_many :items
  has_many :bids, foreign_key: :bidder_id

  MIN_PASSWORD_LENGTH = 8
  
  def password
    @password ||= BCrypt::Password.new(self.password_hash)
  end

  def password=(new_plain_text_password)
    @password = BCrypt::Password.create(new_plain_text_password)
    self.password_hash = @password
  end

  def authenticate(plain_text_password)
    self.password == plain_text_password
  end

  def self.min_passwd_length?(plain_text_password)
    plain_text_password.length >= MIN_PASSWORD_LENGTH
  end
  
  def winning_bids
    bid_item_ids = Bid.where(bidder: self).pluck(:item_id)
    inactive_bid_items = Item.where(id: bid_item_ids).where('auction_end < :now', now: DateTime.now)
    winning_bids = inactive_bid_items.map{|i| i.bids.order(price: :desc).first}
    winning_bids.select{|b| b.bidder == self }
  end

  def won_items
    winning_bids.map(&:item)
  end

end



