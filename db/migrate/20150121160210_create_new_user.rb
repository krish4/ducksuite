class CreateNewUser < ActiveRecord::Migration
  def change
    User.create(name: 'Test user', email: 'user@ducksuite.com', password: 'test123')
  end
end
