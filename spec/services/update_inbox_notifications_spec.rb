require 'rails_helper'

RSpec.describe UpdateInboxNotifications do

  let(:album_id)   { 1 }
  let(:redis_db)   { InMemoryRedis.new }
  let(:cache_name) { CacheName.inbox_notifications(album_id) }

  it 'caches a notification if there are new pictures' do
    allow_any_instance_of(UpdateInboxNotifications).to receive(:unseen_pictures_number).and_return(33)
    UpdateInboxNotifications.new(album_id, redis_db).call
    expect(redis_db.redis[cache_name].length).to eq 1
    expect(JSON.parse(redis_db.redis[cache_name][0])["unseen_pictures_number"]).to eq 33
  end

  it 'does not cache a notification if there are no new pictures' do
    allow_any_instance_of(UpdateInboxNotifications).to receive(:unseen_pictures_number).and_return(0)
    UpdateInboxNotifications.new(album_id, redis_db).call
    expect(redis_db.redis[cache_name]).to eq nil
  end

end
