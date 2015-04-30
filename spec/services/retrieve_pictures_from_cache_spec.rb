require 'rails_helper'

RSpec.describe RetrievePicturesFromCache do

  let(:redisDb)   { InMemoryRedis.new }
  let(:album_id)  { 1 }
  let(:pictures)  { [{ tags: ['john', 'doe'], type: 'image', id: 666}] }

  context 'when old pictures' do
    let(:album_name)  { CacheName.old_album_name(album_id) }

    before(:each) do
      CachePictures.new(pictures, album_id, redisDb).call
      expect(redisDb.redis[album_name].length).to eq 1
      expect(redisDb.redis[album_name][0]).to eq pictures[0].to_json
    end

    it 'retrieves old pictures from the cache' do
      cached_pictures = RetrievePicturesFromCache.new(album_name, redisDb).call
      expect(cached_pictures.length).to eq 1
      expect(cached_pictures[0]["id"]).to eq pictures[0][:id]
    end
  end

  context 'when new pictures' do
    let(:album_name)  { CacheName.new_album_name(album_id) }

    before(:each) do
      allow_any_instance_of(CachePictures).to receive(:update_pictures_notification_data)
      CachePictures.new(pictures, album_id, redisDb, true).call
      expect(redisDb.redis[album_name].length).to eq 1
      expect(redisDb.redis[album_name][0]).to eq pictures[0].to_json
    end

    it 'retrieves new pictures from the cache' do
      cached_pictures = RetrievePicturesFromCache.new(album_name, redisDb).call
      expect(cached_pictures.length).to eq 1
      expect(cached_pictures[0]["id"]).to eq pictures[0][:id]
    end
  end
end
