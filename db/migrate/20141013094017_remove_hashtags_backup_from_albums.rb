class RemoveHashtagsBackupFromAlbums < ActiveRecord::Migration
  def change
    remove_column :albums, :hashtags_backup
  end
end
