require 'rails_helper'

RSpec.describe RemoveUserAlbumFromCache do

  let(:redisDb)     { InMemoryRedis.new }
  let(:user)        { create(:user_with_albums) }
  let(:cache_name)  { CacheName.user_albums_name(user.id) }

  before(:each)     { CacheUserAlbums.new(user.id, redisDb).call }

  it "removes user's album from the cache" do
    service = RemoveUserAlbumFromCache.new(user.id, user.albums.first.id, redisDb)  
    expect{ service.call }.to change{ redisDb.redis[cache_name].length }.by -1
  end
end