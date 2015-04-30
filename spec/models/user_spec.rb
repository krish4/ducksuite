require 'rails_helper'

RSpec.describe User, type: :model do

  it "has a valid factory" do
    expect(build(:user)).to be_valid
  end

  it "is invalid without a name" do
    user = build(:user, name: nil)
    expect(user).to have_at_least(1).errors_on(:name)
  end

  it "is invalid without an email address" do
    user = build(:user, email: nil)
    expect(user).to have_at_least(1).errors_on(:email)
  end

  it "is invalid without a password" do
    user = build(:user, password: nil)
    expect(user).to have_at_least(1).errors_on(:password)
  end  

  it "is invalid with a duplicate email address" do
    create(:user, email: "reserved@test.com")
    user = build(:user, email: "reserved@test.com")
    expect(user).to have_at_least(1).errors_on(:email)
  end

end
