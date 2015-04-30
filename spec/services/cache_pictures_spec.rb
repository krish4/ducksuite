require 'rails_helper'

RSpec.describe CachePictures do

  let(:album_id)        { 1 }
  let(:redisDb)         { InMemoryRedis.new }
  let(:new_album_name)  { CacheName.new_album_name(album_id) }
  let(:old_album_name)  { CacheName.old_album_name(album_id) }
  let(:pictures1)       { [{ tags: ['john', 'doe'], type: 'image', id: 666}] }
  let(:pictures2)       { [{ tags: ['john', 'doe'], type: 'image', id: 999}] }

  before(:each)         { allow_any_instance_of(CachePictures).to receive(:update_pictures_notification_data) }

  it 'should cache picture in empty set' do
    CachePictures.new(pictures1, album_id, redisDb).call
    expect(redisDb.redis[old_album_name].length).to eq 1
    expect(redisDb.redis[old_album_name][0]).to eq pictures1[0].to_json
    expect(redisDb.redis[new_album_name]).to eq nil
  end

  it 'should cache picture in not empty set' do
    CachePictures.new(pictures1, album_id, redisDb).call
    CachePictures.new(pictures2, album_id, redisDb).call
    expect(redisDb.redis[old_album_name].length).to eq 2
    expect(redisDb.redis[old_album_name][0]).to eq pictures1[0].to_json
    expect(redisDb.redis[old_album_name][1]).to eq pictures2[0].to_json
    expect(redisDb.redis[new_album_name]).to eq nil
  end

  it 'should not cache existing picture' do
    CachePictures.new(pictures1, album_id, redisDb).call
    CachePictures.new(pictures1, album_id, redisDb).call
    expect(redisDb.redis[old_album_name].length).to eq 1
    expect(redisDb.redis[old_album_name][0]).to eq pictures1[0].to_json
    expect(redisDb.redis[new_album_name]).to eq nil
  end

  it 'should cache new picture in separate set' do
    CachePictures.new(pictures1, album_id, redisDb, true).call
    expect(redisDb.redis[new_album_name].length).to eq 1
    expect(redisDb.redis[new_album_name][0]).to eq pictures1[0].to_json
    expect(redisDb.redis[old_album_name]).to eq nil
  end

  it 'should not cache new picture if it exist in old set' do
    CachePictures.new(pictures1, album_id, redisDb).call
    CachePictures.new(pictures1, album_id, redisDb, true).call
    expect(redisDb.redis[old_album_name].length).to eq 1
    expect(redisDb.redis[old_album_name][0]).to eq pictures1[0].to_json
    expect(redisDb.redis[new_album_name]).to eq nil
  end

  it 'should not cache old picture if it exist in new set' do
    CachePictures.new(pictures1, album_id, redisDb, true).call
    CachePictures.new(pictures1, album_id, redisDb).call
    expect(redisDb.redis[new_album_name].length).to eq 1
    expect(redisDb.redis[new_album_name][0]).to eq pictures1[0].to_json
    expect(redisDb.redis[old_album_name]).to eq nil
  end

  it 'should not cache new picture if it is approved' do
    CacheAcceptedPicture.new(pictures1[0], album_id, redisDb).call
    CachePictures.new(pictures1, album_id, redisDb).call
    expect(redisDb.redis[old_album_name]).to eq nil
    expect(redisDb.redis[new_album_name]).to eq nil
  end

  it 'should not cache new picture if it is denied' do
    CacheDeniedPicture.new(pictures1[0], album_id, redisDb).call
    CachePictures.new(pictures1, album_id, redisDb).call
    expect(redisDb.redis[old_album_name]).to eq nil
    expect(redisDb.redis[new_album_name]).to eq nil
  end

end
