require 'rails_helper'

RSpec.describe "Users API", type: :request do

  before do
    allow_any_instance_of(API::UsersController).to receive(:check_access)
  end

  describe "GET #index" do
    it "returns an array of users" do
      users = create_list(:user, 10)
      get "/api/users", format: :json
      expect(json).to have(10).items
      expect(json[0][:name]).to eql(users[0].name)
      expect(json[9][:name]).to eql(users[9].name)
    end

    it "returns JSON Content-Type" do
      get "/api/users", format: :json
      expect(response.header['Content-Type']).to include('application/json')
    end

    it "returns 'success' status code: 200" do
      get "/api/users", format: :json
      expect(response).to have_http_status :ok
    end
  end

  describe "GET #show" do
    it "returns single user" do
      user = create(:user)
      get "/api/users/#{user.id}", format: :json
      expect(json[:user][:name]).to eql(user.name)
    end

    it "returns JSON Content-Type" do
      user = create(:user)
      get "/api/users/#{user.id}", format: :json
      expect(response.header['Content-Type']).to include('application/json')
    end

    it "returns 'success' status code: 200" do
      user = create(:user)
      get "/api/users/#{user.id}", format: :json
      expect(response).to have_http_status :ok
    end
  end

  describe "POST #create" do
    it "creates single user" do
      user_attrs = attributes_for(:user)
      post "/api/users", { user: user_attrs }.to_json, { 'Accept' => Mime::JSON, 'Content-Type' => Mime::JSON.to_s }
      expect(json[:name]).to eql(user_attrs[:name])
    end

    it "returns JSON Content-Type" do
      post "/api/users", { user: attributes_for(:user) }.to_json, { 'Accept' => Mime::JSON, 'Content-Type' => Mime::JSON.to_s }
      expect(response.header['Content-Type']).to include("application/json")
    end

    it "returns 'created' status code: 201" do
      post "/api/users", { user: attributes_for(:user) }.to_json, { 'Accept' => Mime::JSON, 'Content-Type' => Mime::JSON.to_s }
      expect(response).to have_http_status :created
    end
  end

  describe "PUT #update" do
    it "updates user's attributes" do
      user = create(:user, name: "Michael Scofield")
      put "/api/users/#{user.id}", { user: { name: "Jackie Chan" } }.to_json, { 'Accept' => Mime::JSON, 'Content-Type' => Mime::JSON.to_s }
      expect(user.reload.name).to eql("Jackie Chan")
    end

    it "returns 'no_content' status code: 204" do
      user = create(:user, name: "Michael Scofield")
      put "/api/users/#{user.id}", { user: { name: "Jackie Chan" } }.to_json, { 'Accept' => Mime::JSON, 'Content-Type' => Mime::JSON.to_s }
      expect(response).to have_http_status :no_content
    end
  end

  describe "DELETE #destroy" do
    it "destroys user" do
      user = create(:user)
      expect{ delete "/api/users/#{user.id}" }.to change(User, :count).by(-1)
    end

    it "returns 'no_content' status code: 204" do
      user = create(:user)
      delete "/api/users/#{user.id}"
      expect(response).to have_http_status :no_content
    end
  end
end
