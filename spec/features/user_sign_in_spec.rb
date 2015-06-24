require 'rails_helper'

feature 'Signing In' do
  let(:john) { create_user }

  scenario 'Signing in with the correct credentials' do

    visit new_user_session_path
    within("#new_user") do
      fill_in 'Email or Username', :with => john.email
      fill_in 'Password', :with => john.password
    end

    click_button 'Log In'
    expect(page).to have_content 'Signed in successfully.'
  end
end