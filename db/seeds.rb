# Delete current DB contents
User.delete_all
Condition.delete_all
Item.delete_all

# Create Users
User.create!({
  name: "q",
  password: "q",
  email: "q"
  })

User.create!({
  name: "Steve Jobs",
  password: "password",
  email: "steve@apple.com"
  })

User.create!({
  name: "Bill Gates",
  password: "password",
  email: "bill@ms.com"
  })

User.create!({
  name: "William Shatner",
  password: "password",
  email: "kirk@gmail.com"
  })

# 5.times do
#   User.create({
#     name: Faker::Name.first_name,
#     email: Faker::Internet.email,
#     password: "password"
#   })
# end
users = User.all

# # Create conditions
# Condition.create!({ name: "new" })
# Condition.create!({ name: "used" })
# Condition.create!({ name: "mint" })
# Condition.create!({ name: "near-mint" })
# Condition.create!({ name: "good" })
# Condition.create!({ name: "fair" })
# Condition.create!({ name: "poor" })
# Condition.create!({ name: "other" })
# Condition.create!({ name: "unknown" })
# conditions = Condition.all

# Create Items

# #  Closed Items
# 10.times do
#     Item.create({
#     name_title: "(TEST CLOSED) " + Faker::Lorem.sentence,
#     condition: conditions.sample,
#     price: Faker::Number.decimal(2),
#     auction_start: Faker::Time.between(DateTime.now - 10, DateTime.now - 6),
#     auction_end: Faker::Time.between(DateTime.now  - 5, DateTime.now - 1, ),
#     description: Faker::Lorem.paragraph,
#     seller: users.sample
#   })
# end

# # Open Items
# 10.times do
#   Item.create({
#     name_title: "(TEST OPEN) " + Faker::Lorem.sentence,
#     condition: conditions.sample,
#     price: Faker::Number.decimal(2),
#     auction_start: Faker::Time.between(DateTime.now - 5, DateTime.now),
# 	  auction_end: Faker::Time.between(DateTime.now, DateTime.now + 5, ),
# 	  description: Faker::Lorem.paragraph,
#     seller: users.sample
#   })
# end
# items = Item.all

# # Create Bids
# 50.times do
#   Bid.create({
#     price: Faker::Number.decimal(2),
#     item: items.sample,
#     bidder: users.sample
#   })
# end
# bids = Bid.all


puts "SEEDING COMPLETE"
puts "#{User.count} Users created."
puts "#{Condition.count} Conditions created."
puts "#{Item.count} Items created."
puts "#{Bid.count} Bids created."
