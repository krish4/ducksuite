require 'rails_helper'

RSpec.describe RetrieveUserAlbumsFromCache do

  let(:redisDb)     { InMemoryRedis.new }
  let(:user)        { create(:user_with_albums) }
  let(:cache_name)  { CacheName.user_albums_name(user.id) }

  before(:each) do
    CacheUserAlbums.new(user.id, redisDb).call
    expect(redisDb.redis[cache_name].length).to eq user.albums.count
  end

  it 'retrieves user albums from the cache' do
    cached_albums = RetrieveUserAlbumsFromCache.new(user.id, redisDb).call
    expect(cached_albums.length).to eq user.albums.count
  end

end
