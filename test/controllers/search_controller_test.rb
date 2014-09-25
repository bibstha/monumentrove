require_relative "../test_helper"

describe SearchController do

  let(:user1) { create(:user) }
  let(:user2) { create(:user) }

  before do
    category1 = create(:category, name: "Asian", user: user1)
    category2 = create(:category, name: "African", user: user1)

    monument1 = create(:monument, user: user1, name: "Silver Pagoda", category: category1)
    monument2 = create(:monument, user: user1, name: "Great Wall of China", category: category1)
    monument3 = create(:monument, user: user1, name: "African Abu Mena", category: category2)
    monument4 = create(:monument, user: user1, name: "Victoria Falls", category: category2)

    category3 = create(:category, name: "America", user: user2)
    monument5 = create(:monument, user: user2, name: "Agave")
  end
  
  it "unauthenticated users cannot search" do
    get :search
    assert_redirected_to new_user_session_path
  end

  it "has no result by default" do
    sign_in user1
    get :search
    @response.body.must_have_content "Results: 0"
  end

  it "shows results given a query string" do
    sign_in user1
    get :search, query: "wall"
    @response.body.must_have_content "Results: 1"
    @response.body.must_have_content "Great Wall of China"
  end

end
