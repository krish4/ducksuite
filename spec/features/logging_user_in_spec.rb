require 'rails_helper'

feature "Logging user in" do
  background do
    @user = create(:user)
  end

  scenario "with correct credentials" do
    visit '/users/sign_in'
    within("#new_user") do
      fill_in 'E-mail', with: @user.email
      fill_in 'Password', with: @user.password
    end
    click_button 'Log in'
    expect(page).not_to have_content 'Log in'
    expect(page).to have_content 'DASHBOARD'
  end

  scenario "with incorrect credentials" do
    visit '/users/sign_in'
    within("#new_user") do
      fill_in 'E-mail', with: ''
      fill_in 'Password', with: ''
    end
    click_button 'Log in'
    expect(page).to have_content 'Log in'
    expect(page).not_to have_content 'DASHBOARD'
  end

end