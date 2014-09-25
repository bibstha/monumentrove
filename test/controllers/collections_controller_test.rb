require "test_helper"

describe CollectionsController do
  
  describe ":index" do
    it "should redirect to user_session_path if unauthenticated" do
      get :index
      assert_redirected_to user_session_path
    end

    it "does not redirect if valid user" do
      user = create(:user)
      sign_in user

      get :index
      assert_response :success
    end

    it "lists only collections belonging to the user" do
      user1 = create(:user)
      user2 = create(:user)

      collection1 = create(:collection, user: user1, name: "Collection 1")
      collection2 = create(:collection, user: user2, name: "Collection 2")

      sign_in user1

      get :index
      assert_response :success
      @response.body.must_have_content "Collection 1"
      @response.body.wont_have_content "Collection 2"
    end
  end

  describe "#show" do
    it "doesn't allow unauthenticated user to access collection" do
      collection = create(:collection)

      get :show, id: collection.id
      assert_response :redirect
      assert_redirected_to user_session_path
    end

    it "doesn't allow user to access collection belonging to another user" do
      user1 = create(:user)
      user2 = create(:user)

      collection1 = create(:collection, user: user1, name: "Collection 1")

      sign_in user2

      proc { get :show, id: collection1.id }.must_throw Exception
      # assert_response 404
    end

    it "allows user to see his own content" do
      user = create(:user)
      collection = create(:collection, user: user, name: "Collection 1")      

      sign_in user

      get :show, id: collection.id
      assert_response :success
      @response.body.must_have_content "Collection 1"
    end
  end
end
