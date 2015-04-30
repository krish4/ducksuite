require 'rails_helper'

RSpec.describe RemoveAcceptedFromCache do

  let(:album_id)    { 1 }
  let(:redisDb)     { InMemoryRedis.new }
  let(:album_name)  { CacheName.accepted_album_name(album_id) }
  let(:picture)     { { tags: ['john', 'doe'], type: 'image', id: 666} }

  before(:each)     { CacheAcceptedPicture.new(picture, album_id, redisDb).call }

  it 'checks if there is a picture to remove' do
    expect(redisDb.redis[album_name].length).to eq 1
    expect(redisDb.redis[album_name][0]).to eq picture.to_json
  end

  it 'removes the picture from the cache' do
    RemoveAcceptedFromCache.new(picture, album_id, redisDb).call
    expect(redisDb.redis[album_name].length).to eq 0
  end
end
