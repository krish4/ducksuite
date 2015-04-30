class CreateAlbums < ActiveRecord::Migration
  def change
    create_table :albums do |t|
      t.string :title
      t.text :hashtags
      t.integer :min_followers_number,  default: 0
      t.integer :min_likes_number,      default: 0
      t.integer :min_comments_number,   default: 0
      t.boolean :is_published, default: false
      t.references :user, index: true

      t.timestamps
    end
  end
end
