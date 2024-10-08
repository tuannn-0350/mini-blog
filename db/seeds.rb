# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)


User.create!(name: "Example User",
            email: "abc@de.com",
            password: "Aa123456",
            password_confirmation: "Aa123456")

20.times do |n|
  name = Faker::Name.name[0..19]
  email = "example-#{n+1}@#{n+1}.com"
  password = "Password1"
  User.create!(name: name,
              email: email,
              password: password,
              password_confirmation: password)
end

users = User.order(:created_at).take(10)

20.times do
  title = Faker::Lorem.sentence(word_count: 5)
  body = Faker::Lorem.sentence(word_count: 100)
  users.each { |user| user.posts.create!(title: title, body: body) }
end
