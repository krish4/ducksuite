require 'rails_helper'

RSpec.describe CacheDeniedPicture do

  let(:album_id)    { 1 }
  let(:redisDb)     { InMemoryRedis.new }
  let(:picture)     { { tags: ['john', 'doe'], type: 'image', id: 666} }
  let(:album_name)  { CacheName.denied_pictures_store(album_id) }

  it 'saves picture data in denied cache' do
    CacheDeniedPicture.new(picture, album_id, redisDb).call
    expect(redisDb.redis[album_name].length).to eq 1
    expect(redisDb.redis[album_name][0]).to eq picture.to_json
  end
end