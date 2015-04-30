require 'rails_helper'

describe "API::DomainsController", type: :request do

  before do
    allow_any_instance_of(API::DomainsController).to receive(:check_access)
  end

  describe "POST #create" do
    let(:user) { create(:user) }
    let(:domain) { build(:domain, user: user) }

    it 'creates the domain' do
      post "/api/domains", domain.to_json, { 'Accept' => Mime::JSON, 'Content-Type' => Mime::JSON.to_s }
      expect(json[:name]).to eq domain.name
      expect(json[:user_id]).to eq user.id
    end
  end

  describe 'DELETE #destroy' do
    let!(:domain) { create(:domain) }

    it 'deletes the domain' do
      expect {
        delete "/api/domains/#{domain.id}"
      }.to change { Domain.count }.from(1).to(0)
    end
  end

  describe "allows domain" do

    context "when domain not saved" do
      it "does not allow domain with www" do
        expect(Domain.allows?("www.example.com")).to eq false
      end
      it "does not allow domain without www" do
        expect(Domain.allows?("example.com")).to eq false
      end
    end

    context "when domain saved with www" do
      before(:each) { create(:domain, name: 'www.example.com') }
      
      it "allows domain with www" do
        expect(Domain.allows?("www.example.com")).to eq true
      end
      it "allows domain without www" do
        expect(Domain.allows?("example.com")).to eq true
      end
    end

    context "when domain saved without www" do
      before(:each) { create(:domain, name: 'example.com') }
      
      it "allows domain with www" do
        expect(Domain.allows?("www.example.com")).to eq true
      end
      it "allows domain without www" do
        expect(Domain.allows?("example.com")).to eq true
      end
    end
  end
end
