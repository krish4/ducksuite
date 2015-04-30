require 'rails_helper'

RSpec.describe RemoveInboxNotifications do

  let(:album_id)   { 1 }
  let(:redis_db)   { InMemoryRedis.new }
  let(:cache_name) { CacheName.inbox_notifications(album_id) }

  before do
    allow_any_instance_of(UpdateInboxNotifications).to receive(:unseen_pictures_number).and_return(33)
    UpdateInboxNotifications.new(album_id, redis_db).call
  end

  it 'removes inbox notifications' do
    expect(redis_db.redis[cache_name].length).to eq 1
    RemoveInboxNotifications.new(album_id, redis_db).call
    expect(redis_db.redis[cache_name].length).to eq 0
  end
end
