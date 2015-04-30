require 'rails_helper'

RSpec.describe CacheUserAlbums do

  let(:redisDb)     { InMemoryRedis.new }
  let(:cache_name)  { CacheName.user_albums_name(user.id) }

  context 'when single user album' do
    let(:user)  { create(:user_with_album) }
    
    it 'caches user album' do
      CacheUserAlbums.new(user.id, redisDb).call
      expect(redisDb.redis[cache_name].length).to eq 1
    end
  end

  context 'when many albums' do
    let(:user) { create(:user_with_albums) }

    it 'caches user albums' do
      CacheUserAlbums.new(user.id, redisDb).call
      expect(redisDb.redis[cache_name].length).to eq user.albums.count
    end
  end

end
