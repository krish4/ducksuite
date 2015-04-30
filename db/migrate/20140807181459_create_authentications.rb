class CreateAuthentications < ActiveRecord::Migration
  def change
    create_table :authentications do |t|
      t.string :uid,          null: false
      t.string :provider,     null: false
      t.string :access_token, null: false
      t.references :user,     index: true
      t.timestamps
    end
  end
end
