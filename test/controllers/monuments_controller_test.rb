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

    it "contains picture upload form" do
      monument = create(:monument, name: "Monument 1")
      sign_in monument.user
      get :show, id: monument.id
      @response.body.must_have_field :picture_file
      @response.body.must_have_field :picture_name
      @response.body.must_have_field :picture_description
      @response.body.must_have_field :picture_date
    end

    it "lists all pictures attached" do
      picture1 = create(:picture)
      common_monument = picture1.monument
      picture2 = create(:picture, monument: common_monument)
      sign_in common_monument.user
      get :show, id: picture1.monument.id
      @response.body.must_have_content "Picture #1"
      @response.body.must_have_content "Picture #2"
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
      user       = create(:user)
      collection = create(:collection, name: "Collection A", user: user)
      category   = create(:category, name: "Category 1", user: user)

      sign_in user
      post :create, monument: {name: "Monument A", description: "Desc", collection_id: collection.id, 
        category_id: category.id}

      saved_monument = user.monuments.first
      saved_monument.name.must_equal "Monument A"
      saved_monument.description.must_equal "Desc"
      saved_monument.collection.must_equal collection
      saved_monument.category.must_equal category
    end
  end

  describe "#edit" do
    it "contains form with pre filled values" do
      user       = create(:user)
      collection = create(:collection, name: "Collection A", user: user)
      category   = create(:category, name: "Category 1", user: user)
      monument = create(:monument, name: "Monument A", collection: collection, category: category, user: user)
      sign_in user
      get :edit, id: monument.id
      
      @response.body.must_have_field  "monument_name", with: "Monument A"
      @response.body.must_have_select "monument_collection_id", options: ["Collection A"]
      @response.body.must_have_select "monument_category_id",   options: ["Category 1"]
      @response.body.must_have_button "Update Monument"
    end
  end

  describe "#update" do
    it "updates the name of the monument" do
      user       = create(:user)
      collection1 = create(:collection, name: "Collection A", user: user)
      collection2 = create(:collection, name: "Collection B", user: user)
      category1   = create(:category, name: "Category 1", user: user)
      category2   = create(:category, name: "Category 2", user: user)
      monument = create(:monument, name: "Monument A", description: "Desc", collection: collection1, category: category1, user: user)
      sign_in user
      patch :update, id: monument.id, monument: {name: "Monument B", description: "Desc2", collection_id: collection2.id, 
        category_id: category2.id}

      saved_monument = Monument.find(monument.id)
      saved_monument.name.must_equal "Monument B"
      saved_monument.description.must_equal "Desc2"
      saved_monument.category.must_equal category2
      saved_monument.collection.must_equal collection2
    end
  end

end
