require 'rails_helper'

RSpec.describe CountInboxPictures do

  let(:album_id)          { 1 }
  let(:redisDb)           { InMemoryRedis.new }
  let(:inbox)             { Inbox.new(1) }
  let(:pictures1)         { [{ tags: ['john', 'doe'], type: 'image', id: 666 }] }
  let(:pictures2)         { [{ tags: ['john', 'doe'], type: 'image', id: 999 }] }

  before(:each) do 
    allow_any_instance_of(CachePictures).to receive(:update_pictures_notification_data)
    prepare_state
  end

  context 'when inbox not visited' do
    it 'counts all pictures in inbox' do
      service = CountInboxPictures.new(redisDb, album_id)
      expect(service.call).to eq 2
    end
  end

  context 'when inbox visited' do
    it 'counts pictures fetched after last inbox visit' do
      inbox.visited!
      service = CountInboxPictures.new(redisDb, album_id, count_only_new = true)
      expect(service.call).to eq 0
    end
  end

  private

  def prepare_state
    inbox.save
    CachePictures.new(pictures1, album_id, redisDb).call
    CachePictures.new(pictures2, album_id, redisDb, true).call
  end
end