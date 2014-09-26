require_relative "../test_helper"

describe PicturesController do

  describe "#show" do
    it "doesn't allow unauthenticated user to access picture" do
      picture = create(:picture)
      get :show, id: picture.id, monument_id: picture.monument.id
      assert_response :redirect
      assert_redirected_to user_session_path
    end

    it "doesn't allow user to access picture belonging to another user" do
      user1 = create(:user)
      user2 = create(:user)
      monument = create(:monument, user: user1)
      picture1 = create(:picture, name: "Picture 1", monument: monument)

      sign_in user2

      proc { get :show, id: picture1.id, monument_id: monument }.must_raise ActiveRecord::RecordNotFound
    end

    it "allows user to see his own content" do
      picture = create(:picture, name: "Picture 1")
      sign_in picture.monument.user

      get :show, id: picture.id, monument_id: picture.monument
      assert_response :success
      @response.body.must_have_content "Picture 1"
    end
  end

  describe "#destroy" do
    it "redirects unauthorized user when deleting picture" do
      picture = create(:picture)
      delete :destroy, id: picture.id, monument_id: picture.monument
      assert_response :redirect
      assert_redirected_to user_session_path
    end

    it "doesn't allow user to delete picture belong to another user" do
      picture = create(:picture)
      another_user = create(:user)
      sign_in another_user
      proc { delete :destroy, id: picture.id, monument_id: picture.monument.id }.must_raise ActiveRecord::RecordNotFound
    end

    it "allows user to delete own picture" do
      picture = create(:picture)
      sign_in picture.monument.user
      delete :destroy, id: picture.id, monument_id: picture.monument.id
      Picture.wont_be :exists?, picture
    end
  end

  describe "#create" do
    it "associate picture with monument" do
      monument = create(:monument)
      sign_in monument.user
      post :create, monument_id: monument.id, picture: {name: "Picture A", description: "Desc", date: "2014/01/30", 
        image: fixture_file_upload("eifel_tower.jpg", "image/jpg") }

      monument.pictures.first.name.must_equal "Picture A"
      monument.pictures.first.image_file_name.must_equal "eifel_tower.jpg"
    end
  end

  describe "#edit" do
    it "contains form with pre filled values" do
      picture = create(:picture, name: "Picture A")
      sign_in picture.monument.user
      get :edit, id: picture.id, monument_id: picture.monument.id
      @response.body.must_have_field "picture_name", with: "Picture A"
    end
  end

  describe "#update" do
    it "updates the name of the picture" do
      picture = create(:picture, name: "Picture A")
      sign_in picture.monument.user
      patch :update, id: picture.id, monument_id: picture.monument.id, picture: {name: "Picture B"}

      Picture.find(picture.id).name.must_equal "Picture B"
    end
  end

end
