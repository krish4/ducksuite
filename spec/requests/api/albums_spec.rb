require 'rails_helper'

RSpec.describe "Albums API", type: :request do

  before do
    allow_any_instance_of(API::AlbumsController).to receive(:check_access)
  end

  describe "GET #index" do

    let(:user)    { create(:user_with_albums) }
    before(:each) { login_user(user) }
      
    it "returns an array of albums being logged in" do
      REDIS.flushdb
      get "/api/albums", format: :json
      expect(json).to have(user.albums.count).items
    end

    it "returns JSON Content-Type" do
      get "/api/albums", format: :json
      expect(response.header['Content-Type']).to include('application/json')
    end

    it "returns 'success' status code: 200" do
      get "/api/albums", format: :json
      expect(response).to have_http_status :ok
    end
  end

  describe "GET #show" do
    it "returns single album" do
      album = create(:album)
      get "/api/albums/#{album.id}", format: :json
      expect(json[:title]).to eql(album.title)
    end

    it "returns JSON Content-Type" do
      album = create(:album)
      get "/api/albums/#{album.id}", format: :json
      expect(response.header['Content-Type']).to include('application/json')
    end

    it "returns 'success' status code: 200" do
      album = create(:album)
      get "/api/albums/#{album.id}", format: :json
      expect(response).to have_http_status :ok
    end
  end

  describe "POST #create" do
    it "creates single album" do
      album = build(:album)
      post "/api/albums", album.to_json, { 'Accept' => Mime::JSON, 'Content-Type' => Mime::JSON.to_s }
      expect(json[:title]).to eql(album.title)
    end

    it "returns JSON Content-Type" do
      post "/api/albums", build(:album).to_json, { 'Accept' => Mime::JSON, 'Content-Type' => Mime::JSON.to_s }
      expect(response.header['Content-Type']).to include("application/json")
    end

    it "returns 'created' status code: 201" do
      post "/api/albums", build(:album).to_json, { 'Accept' => Mime::JSON, 'Content-Type' => Mime::JSON.to_s }
      expect(response).to have_http_status :created
    end
  end

  describe "PUT #update" do
    it "updates album's attributes" do
      album = create(:album, title: "Horrible photos...")
      put "/api/albums/#{album.id}", { album: { title: "Beautiful pictures!" } }.to_json, { 'Accept' => Mime::JSON, 'Content-Type' => Mime::JSON.to_s }
      expect(album.reload.title).to eql("Beautiful pictures!")
    end

    it "returns 'no_content' status code: 204" do
      album = create(:album, title: "Horrible photos...")
      put "/api/albums/#{album.id}", { album: { title: "Beautiful pictures!" } }.to_json, { 'Accept' => Mime::JSON, 'Content-Type' => Mime::JSON.to_s }
      expect(response).to have_http_status :no_content
    end
  end

  describe "DELETE #destroy" do
    let(:user)     { create(:user_with_album) }
    let(:album_id) { user.albums.first.id }
    before(:each)  { login_user(user) }
    
    it "destroys album" do
      expect{ delete "/api/albums/#{album_id}" }.to change(Album, :count).by(-1)
    end

    it "returns 'no_content' status code: 204" do
      delete "/api/albums/#{album_id}"
      expect(response).to have_http_status :no_content
    end
  end

end
