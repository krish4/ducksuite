require 'rails_helper'
require 'pry'
RSpec.describe CacheName do
  let(:album_id) { 1 }

  it 'old_album_name' do
    expect(CacheName.old_album_name(album_id)).to eq 'album_1'
  end

  it 'new_album_name' do
    expect(CacheName.new_album_name(album_id)).to eq 'album_1_new'
  end

  it 'accepted_album_name' do
    expect(CacheName.accepted_album_name(album_id)).to eq 'album_1_accepted'
  end

  it 'denied_pictures_store' do
    expect(CacheName.denied_pictures_store(album_id)).to eq 'album_1_denied'
  end
end