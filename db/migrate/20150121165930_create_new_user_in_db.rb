class CreateNewUserInDb < ActiveRecord::Migration
  def change
    User.create(name: 'Test user2', email: 'user2@ducksuite.com', password: 'test123')
  end
end
