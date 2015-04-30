require 'rails_helper'

RSpec.describe "BaseController", type: :request do

  let(:user)       { create(:user_with_albums) }
  let(:album_id)   { user.albums.last.id }
  let(:albums_url) { "/api/albums/#{album_id}" }

  context "when domain whitelisted" do
    describe "in a database" do
      context "with www in url address" do
        let!(:domain) { create(:domain, name: 'www.example.com', user: user) }
        it 'grants an access to the site' do
          get albums_url, format: :json
          expect(response).to have_http_status 200
        end
      end

      context "without www in url address" do
        let!(:domain) { create(:domain, name: 'example.com', user: user) }
        it 'grants an access to the site' do
          get albums_url, format: :json
          expect(response).to have_http_status 200
        end
      end
    end

    describe "in an ENV variable" do
      it 'grants an access to the site' do
        with_modified_env WHITELISTED_DOMAINS: '["www.example.com"]' do
          get albums_url, format: :json
          expect(response).to have_http_status 200
        end 
      end
    end
  end
  
  context "when domain not whitelisted" do
    it 'refuses an access to the site' do
      get albums_url, format: :json
      expect(response).to have_http_status 403
    end
  end
end
