require "test_helper"
require_relative "support/helpers"

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

      collection1   = create(:collection, user: user1, name: "Collection A")
      collection1_2 = create(:collection, user: user1, name: "Collection B")
      collection2 = create(:collection, user: user2, name: "Collection C")

      sign_in user1

      get :index
      assert_response :success
      @response.body.must_have_content "Collection A"
      @response.body.must_have_content "Collection B"
      @response.body.wont_have_content "Collection C"
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

      proc { get :show, id: collection1.id }.must_raise ActiveRecord::RecordNotFound
    end

    it "allows user to see his own content" do
      collection = create(:collection, name: "Collection 1")      

      sign_in collection.user

      get :show, id: collection.id
      assert_response :success
      @response.body.must_have_content "Collection 1"
    end
  end

  describe "#destroy" do
    it "redirects unauthorized user when deleting collection" do
      collection = create(:collection)
      delete :destroy, id: collection.id
      assert_response :redirect
      assert_redirected_to user_session_path
    end

    it "doesn't allow user to delete collection belong to another user" do
      collection = create(:collection)
      another_user = create(:user)
      sign_in another_user
      proc { delete :destroy, id: collection.id }.must_raise ActiveRecord::RecordNotFound
    end

    it "allows user to delete own collection" do
      collection = create(:collection)
      sign_in collection.user
      delete :destroy, id: collection.id
      Collection.wont_be :exists?, collection
    end
  end

  describe "#new" do
    it "contains form for new collection entry" do
      user = create(:user)
      sign_in user
      get :new
      @response.body.must_have_field  "collection_name"
      @response.body.must_have_button "Create Collection"
    end
  end

  describe "#create" do
    it "associates collection with signed in user" do
      user = create(:user)
      sign_in user
      post :create, collection: {name: "Collection A"}
      user.collections.first.name.must_equal "Collection A"
    end
  end

  describe "#edit" do
    it "contains form with pre filled values" do
      collection = create(:collection, name: "Collection A")
      sign_in collection.user
      get :edit, id: collection.id
      @response.body.must_have_field "collection_name", with: "Collection A"
    end
  end

  describe "#update" do
    it "updates the name of the collection" do
      collection = create(:collection, name: "Collection A")
      sign_in collection.user
      patch :update, id: collection.id, collection: {name: "Collection B"}

      Collection.find(collection.id).name.must_equal "Collection B"
    end
  end

end
