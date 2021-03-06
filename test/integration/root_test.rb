require 'test_helper'

class RootTest < ActionDispatch::IntegrationTest
  fixtures :all

  test "root url loads" do
    get "/"

    # The page always loads
    assert_response :success

    # And it should never ever ever redirect
    assert !redirect?
  end

  test "root url shows login when not public" do
    ConcertoConfig.set('public_concerto', false)
    
    get "/"
    assert_redirected_to new_user_session_path

    ConcertoConfig.set('public_concerto', true)
  end

  test "signed in root urls load" do
    post "/users/sign_in", :user => {:email => users(:katie).email, :password => 'katie'}
    assert_redirected_to dashboard_path
    follow_redirect!
    assert_response :success

    get "/feeds"
    assert_response :success

    get "/feeds/#{feeds(:service).id}/submissions"
    assert_response :success
  end
end
