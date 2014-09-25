module ControllerSupportHelpers
  
  def it_redirects_unauthenticated_user_when(name, &block)
    it "redirects unauthenticated user when #{name}" do
      block.call
      assert_response :redirect
      assert_response user_session_path
    end
  end

  def hello_world
    puts "HELLO WORLD"
  end

end