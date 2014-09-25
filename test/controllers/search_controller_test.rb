require "test_helper"

describe SearchController do
  it "should get search" do
    get :search
    assert_response :success
  end

end
