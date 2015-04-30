require 'rails_helper'

RSpec.describe RemoveFromCache do

  let(:album_id)  { 1 }
  let(:redisDb)   { InMemoryRedis.new }
  let(:pictures)  { [{ tags: ['john', 'doe'], type: 'image', id: 666}] }

  before(:each) do 
    allow_any_instance_of(CachePictures).to   receive(:update_pictures_notification_data)
    allow_any_instance_of(RemoveFromCache).to receive(:update_pictures_notification_data)
  end

  context 'when old picture' do
    let(:album_name)  { CacheName.old_album_name(album_id) }

    before(:each) do
      CachePictures.new(pictures, album_id, redisDb).call
      expect(redisDb.redis[album_name].length).to eq 1
      expect(redisDb.redis[album_name][0]).to eq pictures[0].to_json
    end

    it 'removes the picture from the cache' do
      RemoveFromCache.new(pictures[0], album_id, redisDb).call
      expect(redisDb.redis[album_name].length).to eq 0
    end
  end

  context 'when new picture' do
    let(:album_name)  { CacheName.new_album_name(album_id) }
    
    before(:each) do
      service = CachePictures.new(pictures, album_id, redisDb, true).call
      expect(redisDb.redis[album_name].length).to eq 1
      expect(redisDb.redis[album_name][0]).to eq pictures[0].to_json
    end

    it 'removes the picture from the cache' do
      RemoveFromCache.new(pictures[0], album_id, redisDb).call
      expect(redisDb.redis[album_name].length).to eq 0
    end
  end
end
