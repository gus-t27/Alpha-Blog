require 'test_helper'

class UserSignUpTest < ActionDispatch::IntegrationTest

  test "get sign up form and sign up user" do
    get "/signup"
    assert_response :success
    assert_difference 'User.count', 1 do
      post users_path, params: { user: { username: "sampleuser", email: "sample@email.com", password: "sample" } }
      assert_response :redirect
    end
    follow_redirect!
    assert_response :success
    assert_match "sampleuser", response.body
    assert_match "Logout", response.body
    assert_match "Listing all articles", response.body
  end

  test "get sign up form and reject invalid user submission" do
    get "/signup"
    assert_response :success
    assert_no_difference 'User.count' do
      post users_path, params: { user: { username: " " } }
    end
    assert_match "errors", response.body
    assert_select 'div.alert'
    assert_select 'h4.alert-heading'
  end
end
