class AddClosedAtToUsers < ActiveRecord::Migration
  def change
    add_column :users, :closed_at, :datetime
  end
end
