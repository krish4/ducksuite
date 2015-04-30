require 'rails_helper'

RSpec.describe Authentication, type: :model do
  it "has a valid factory" do
    expect(build(:authentication)).to be_valid
  end

  it "is invalid without user" do
    expect(build(:authentication, user: nil)).to have_at_least(1).errors_on(:user)
  end

  it "is invalid without uid" do
    expect(build(:authentication, uid: nil)).to have_at_least(1).errors_on(:uid)
  end

  it "is invalid without provider" do
    expect(build(:authentication, provider: nil)).to have_at_least(1).errors_on(:provider)
  end

  it "is invalid with disallowed provider" do
    expect(build(:authentication, provider: "instagramos")).to have_at_least(1).errors_on(:provider)
  end

end
