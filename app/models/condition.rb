class Condition < ActiveRecord::Base
  # Remember to create a migration!
  validates :name, {presence: true, uniqueness: true}

  has_many :items
end
