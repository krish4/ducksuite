require 'rails_helper'

RSpec.describe RetrieveInboxNotifications do

  let(:album_id)   { 1 }
  let(:redis_db)   { InMemoryRedis.new }
  let(:cache_name) { CacheName.inbox_notifications(album_id) }

  context 'when some notifications exist' do
    before do
      allow_any_instance_of(UpdateInboxNotifications).to receive(:unseen_pictures_number).and_return(33)
      UpdateInboxNotifications.new(album_id, redis_db).call
    end

    it 'retrieves the notifications' do
      notifications = RetrieveInboxNotifications.new(album_id, redis_db).call
      expect(notifications.length).to eq 1
      expect(notifications[0]["unseen_pictures_number"]).to eq 33
    end
  end

  context 'when there are no notifications' do
    before do
      allow_any_instance_of(UpdateInboxNotifications).to receive(:unseen_pictures_number).and_return(0)
      UpdateInboxNotifications.new(album_id, redis_db).call
    end

    it 'does not retrieve any notifications' do
      expect(redis_db.redis[cache_name]).to eq nil
    end
  end

end
