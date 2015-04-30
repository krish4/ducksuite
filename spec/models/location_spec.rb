require 'rails_helper'

RSpec.describe Location, type: :model do

  it "has a valid factory" do
    expect(build(:location)).to be_valid
  end

  it "is invalid without a name" do
    expect(build(:location, name: nil)).to have(1).errors_on(:name)
  end

  it "is invalid without a latitude" do
    expect(build(:location, latitude: nil)).to have(1).errors_on(:latitude)
  end

  it "is invalid without a longitude" do
    expect(build(:location, longitude: nil)).to have(1).errors_on(:longitude)
  end

  it "is invalid without an album" do
    expect(build(:location, album: nil)).to have(1).errors_on(:album)
  end
end
