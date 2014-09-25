require_relative "../test_helper"

describe MonumentsController do

  describe "#index" do
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

    it "lists only monuments belonging to the user" do
      user1 = create(:user)
      user2 = create(:user)

      monument1   = create(:monument, user: user1, name: "Monument A")
      monument1_2 = create(:monument, user: user1, name: "Monument B")
      monument2 = create(:monument, user: user2, name: "Monument C")

      sign_in user1

      get :index
      assert_response :success
      @response.body.must_have_content "Monument A"
      @response.body.must_have_content "Monument B"
      @response.body.wont_have_content "Monument C"
    end
  end

  describe "#show" do
    it "doesn't allow unauthenticated user to access monument" do
      monument = create(:monument)

      get :show, id: monument.id
      assert_response :redirect
      assert_redirected_to user_session_path
    end

    it "doesn't allow user to access monument belonging to another user" do
      user1 = create(:user)
      user2 = create(:user)

      monument1 = create(:monument, user: user1, name: "Monument 1")

      sign_in user2

      proc { get :show, id: monument1.id }.must_raise ActiveRecord::RecordNotFound
    end

    it "allows user to see his own content" do
      monument = create(:monument, name: "Monument 1")      

      sign_in monument.user

      get :show, id: monument.id
      assert_response :success
      @response.body.must_have_content "Monument 1"
    end
  end

  describe "#destroy" do
    it "redirects unauthorized user when deleting monument" do
      monument = create(:monument)
      delete :destroy, id: monument.id
      assert_response :redirect
      assert_redirected_to user_session_path
    end

    it "doesn't allow user to delete monument belong to another user" do
      monument = create(:monument)
      another_user = create(:user)
      sign_in another_user
      proc { delete :destroy, id: monument.id }.must_raise ActiveRecord::RecordNotFound
    end

    it "allows user to delete own monument" do
      monument = create(:monument)
      sign_in monument.user
      delete :destroy, id: monument.id
      Monument.wont_be :exists?, monument
    end
  end
  
  describe "#new" do
    it "contains form for new monument entry" do
      user = create(:user)
      create(:collection, name: "Collection A", user: user)
      create(:collection, name: "Collection B", user: user)
      create(:category, name: "Category 1", user: user)
      create(:category, name: "Category 2", user: user)
      sign_in user
      get :new

      @response.body.must_have_field "monument_name"
      @response.body.must_have_field "monument_description"
      @response.body.must_have_select "monument_collection_id", options: ["Collection A", "Collection B"]
      @response.body.must_have_select "monument_category_id", options: ["Category 1", "Category 2"]
      @response.body.must_have_button "Create Monument"
    end
  end

  describe "#create" do
    it "associates monument with signed in user" do
      user = create(:user)
      sign_in user
      post :create, monument: {name: "Monument A"}
      user.monuments.first.name.must_equal "Monument A"
    end
  end

  describe "#edit" do
    it "contains form with pre filled values" do
      monument = create(:monument, name: "Monument A")
      sign_in monument.user
      get :edit, id: monument.id
      @response.body.must_have_field "monument_name", with: "Monument A"
    end
  end

  describe "#update" do
    it "updates the name of the monument" do
      monument = create(:monument, name: "Monument A")
      sign_in monument.user
      patch :update, id: monument.id, monument: {name: "Monument B"}

      Monument.find(monument.id).name.must_equal "Monument B"
    end
  end

end
