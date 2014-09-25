require "test_helper"
require_relative "support/helpers"

describe CategoriesController do

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

    it "lists only categories belonging to the user" do
      user1 = create(:user)
      user2 = create(:user)

      category1   = create(:category, user: user1, name: "Category A")
      category1_2 = create(:category, user: user1, name: "Category B")
      category2 = create(:category, user: user2, name: "Category C")

      sign_in user1

      get :index
      assert_response :success
      @response.body.must_have_content "Category A"
      @response.body.must_have_content "Category B"
      @response.body.wont_have_content "Category C"
    end
  end

  describe "#show" do
    it "doesn't allow unauthenticated user to access category" do
      category = create(:category)

      get :show, id: category.id
      assert_response :redirect
      assert_redirected_to user_session_path
    end

    it "doesn't allow user to access category belonging to another user" do
      user1 = create(:user)
      user2 = create(:user)

      category1 = create(:category, user: user1, name: "Category 1")

      sign_in user2

      proc { get :show, id: category1.id }.must_raise ActiveRecord::RecordNotFound
    end

    it "allows user to see his own content" do
      category = create(:category, name: "Category 1")      

      sign_in category.user

      get :show, id: category.id
      assert_response :success
      @response.body.must_have_content "Category 1"
    end
  end

  describe "#destroy" do
    it "redirects unauthorized user when deleting category" do
      category = create(:category)
      delete :destroy, id: category.id
      assert_response :redirect
      assert_redirected_to user_session_path
    end

    it "doesn't allow user to delete category belong to another user" do
      category = create(:category)
      another_user = create(:user)
      sign_in another_user
      proc { delete :destroy, id: category.id }.must_raise ActiveRecord::RecordNotFound
    end

    it "allows user to delete own category" do
      category = create(:category)
      sign_in category.user
      delete :destroy, id: category.id
      Category.wont_be :exists?, category
    end
  end
  
  describe "#new" do
    it "contains form for new category entry" do
      user = create(:user)
      sign_in user
      get :new
      @response.body.must_have_field  "category_name"
      @response.body.must_have_button "Create Category"
    end
  end

  describe "#create" do
    it "associates category with signed in user" do
      user = create(:user)
      sign_in user
      post :create, category: {name: "Category A"}
      user.categories.first.name.must_equal "Category A"
    end
  end

  describe "#update" do
    it "contains form with pre filled values" do
      category = create(:category, name: "Category A")
      sign_in category.user
      get :edit, id: category.id
      @response.body.must_have_field "category_name", with: "Category A"
    end
  end

  describe "#update" do
    it "updates the name of the category" do
      category = create(:category, name: "Category A")
      sign_in category.user
      patch :update, id: category.id, category: {name: "Category B"}

      Category.find(category.id).name.must_equal "Category B"
    end
  end

end
