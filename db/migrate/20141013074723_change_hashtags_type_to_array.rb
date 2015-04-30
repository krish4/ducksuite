class ChangeHashtagsTypeToArray < ActiveRecord::Migration
  def self.up
    rename_column :albums, :hashtags, :hashtags_backup
    add_column :albums, :hashtags, :text, array: true, default: []

    Album.all.each do |album|
      album.hashtags = YAML.load(album.hashtags_backup)
      album.save!
    end
  end

  def self.down
    rename_column :albums, :hashtags, :hashtags_backup
    add_column :albums, :hashtags, :text

    Album.all.each do |album|
      album.hashtags = album.hashtags_backup.to_yaml
      album.save!
    end
  end
end
