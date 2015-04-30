require 'rails_helper'

RSpec.describe CacheAcceptedPicture do

  let(:album_id)    { 1 }
  let(:redisDb)     { InMemoryRedis.new }
  let(:album_name)  { CacheName.accepted_album_name(album_id) }
  let(:picture1)    { [{ tags: ['john', 'doe'], type: 'image', id: 666}] }
  let(:picture2)    { [{ tags: ['john', 'doe'], type: 'image', id: 999}] }

  it 'caches accepted pictures' do
    CacheAcceptedPicture.new(picture1, album_id, redisDb).call
    expect(redisDb.redis[album_name].length).to eq 1
    expect(redisDb.redis[album_name][0]).to eq picture1.to_json

    CacheAcceptedPicture.new(picture2, album_id, redisDb).call
    expect(redisDb.redis[album_name].length).to eq 2
    expect(redisDb.redis[album_name][1]).to eq picture2.to_json
  end

end
