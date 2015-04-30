require 'rails_helper'

RSpec.describe Picture, type: :model do

  it "has a valid factory" do
    expect(build(:picture)).to be_valid
  end

  it "is invalid without instagram_id" do
    expect(build(:picture, instagram_id: nil)).to have(1).errors_on(:instagram_id)
  end

  it "is invalid without associated album" do
    expect(build(:picture, album: nil)).to have(1).errors_on(:album)
  end

  it "sets by default status to 'new'" do
    expect(Picture.new.status).to eql("new")
  end

  it "accepts the following statuses: 'new', 'accepted', 'denied'" do
    expect(build(:picture, status: 'removed')).to have(1).errors_on(:status)
  end

  it "can change status from 'new' to 'accepted'" do
    pic = create(:picture, status: "new")
    pic.accept
    expect(pic.status).to eql("accepted")
  end

  it "can change status from 'new' to 'denied'" do
    pic = create(:picture, status: "new")
    pic.deny
    expect(pic.status).to eql("denied")
  end

  it "can change status from 'accepted' to 'new'" do
    pic = create(:picture, status: "accepted")
    pic.clear
    expect(pic.status).to eql("new")
  end

  it "can change status from 'denied' to 'new'" do
    pic = create(:picture, status: "denied")
    pic.clear
    expect(pic.status).to eql("new")
  end

  it "can change status from 'accepted' to 'denied'" do
    pic = create(:picture, status: "accepted")
    pic.deny
    expect(pic.status).to eql("denied")
  end

  it "can change status from 'denied' to 'accepted'" do
    pic = create(:picture, status: "denied")
    pic.accept
    expect(pic.status).to eql("accepted")
  end
end
