require 'rails_helper'

RSpec.describe Album, type: :model do

  it "has a valid factory" do
    expect(build(:album)).to be_valid
  end

  it "sets by default a minimum likes|comments|followers number to zero" do
    album = build(:album)
    expect(album.min_likes_number).to eql(0)
    expect(album.min_comments_number).to eql(0)
    expect(album.min_followers_number).to eql(0)
  end

  it "is invalid when a minimum likes|comments|followers number is not an integer" do
    expect(build(:album, min_likes_number: 1.5)).to have(1).errors_on(:min_likes_number)
    expect(build(:album, min_comments_number: 1.5)).to have(1).errors_on(:min_comments_number)
    expect(build(:album, min_followers_number: 1.5)).to have(1).errors_on(:min_followers_number)
  end

  it "is invalid when a minimum likes|comments|followers number is less than zero" do
    expect(build(:album, min_likes_number: -1)).to have(1).errors_on(:min_likes_number)
    expect(build(:album, min_comments_number: -1)).to have(1).errors_on(:min_comments_number)
    expect(build(:album, min_followers_number: -1)).to have(1).errors_on(:min_followers_number)
  end

  it "is invalid without a title" do
    expect(build(:album, title: nil)).to have(1).errors_on(:title)
  end

  it "is invalid without hashtags" do
    expect(build(:album, hashtags: nil)).to have(1).errors_on(:hashtags)
  end

  it "is invalid without a user" do
    expect(build(:album, user: nil)).to have(1).errors_on(:user)
  end

  describe "fetches pictures from Instagram" do

    context "without specifying max_id and min_id" do
      before do
        stub_request(:get, /api.instagram.com\/v1\/tags/).to_return(status: 200, body: fixture("tag.json"))
        stub_request(:get, /media\/recent/).to_return(status: 200, body: fixture("tag_recent_media/default.json"))
        album = create(:album)
        @response = FetchPictures.new(nil, album).call
      end

      it "returns correct next_max_id" do
        expect(@response[:next_max_id]).to eq(77)
      end

      it "returns correct next_min_id" do
        expect(@response[:next_min_id]).to eq(100)
      end
    end
  end
end
