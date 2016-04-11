# Delete current DB contents
User.delete_all
Joke.delete_all
JokeTag.delete_all
Tag.delete_all

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

users = User.all

puts "SEEDING COMPLETE"
puts "#{User.count} Users created."
puts "#{Joke.count} Jokes created."
puts "#{JokeTag.count} JokeTags created."
puts "#{Tag.count} Tags created."

