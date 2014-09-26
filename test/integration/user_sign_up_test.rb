require 'test_helper'

describe 'User Sign Up Integration Test' do

  describe "homepage" do
    it "homepage has form" do
      visit root_path

      page.must_have_field "user_email"
      page.must_have_field "user_password"
      page.must_have_button "Sign in"
    end

    it "rejects invalid users" do
      create(:user, email: "testuser@example.com", password: "test_user_pass")
      
      visit root_path
      fill_in "user_email", with: "testuser@example.com"
      fill_in "user_password", with: "wrong_password"
      click_button "Sign in"

      find('.alert div').must_have_content "Invalid email or password."
    end

    it "allows valid user to login" do
      create(:user, email: "testuser@example.com", password: "test_user_pass")
      
      visit root_path
      fill_in "user_email", with: "testuser@example.com"
      fill_in "user_password", with: "test_user_pass"
      click_button "Sign in"

      find('.alert div').must_have_content "Signed in successfully."
      find('.header').must_have_content "testuser@example.com"
    end
  end
  
end
