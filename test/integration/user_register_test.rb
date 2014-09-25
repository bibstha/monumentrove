require 'test_helper'

describe 'User Registration Integration Test' do

  describe "Sign up page" do
    
    it "has registration form" do
      visit new_user_registration_path

      page.must_have_field "user_email"
      page.must_have_field "user_password"
      page.must_have_field "user_password_confirmation"
      page.must_have_button "Sign up"
    end

    it "logs in user automatically" do
      visit new_user_registration_path

      fill_in "user_email", with: "testuser@example.com"
      fill_in "user_password", with: "test_user_pass"
      fill_in "user_password_confirmation", with: "test_user_pass"
      click_button "Sign up"

      find('.alert li').must_have_content "Welcome! You have signed up successfully."
      find('.header .navbar-text').must_have_content "testuser@example.com"

    end

  end
  
end
