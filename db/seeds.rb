# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.create(name: "Lionel Messi", email: "ducksuite@test.com", password: "test123456")
User.create(name: "Jarek Owczarek", email: "jo@woumedia.com", password: "copenhagen12")
User.create(name: "Account test 1", email: "test1@test.com", password: "test123456")
User.create(name: "Account test 2", email: "test2@test.com", password: "test123456")