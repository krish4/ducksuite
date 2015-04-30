class CreatePictures < ActiveRecord::Migration
  def change
    create_table :pictures do |t|
      t.string :instagram_id
      t.string :status
      t.references :album, index: true

      t.timestamps
    end
  end
end
