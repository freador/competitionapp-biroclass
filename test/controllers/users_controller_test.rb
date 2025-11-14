require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "should get new when logged out" do
    get new_user_url
    assert_response :success
  end

  test "should create user and start session" do
    assert_difference("User.count") do
      post users_url, params: { user: { name: "New User", email: "new-user@example.com", password: "password123", password_confirmation: "password123" } }
    end

    assert_redirected_to competitions_url
    follow_redirect!
    assert_response :success
  end

  test "signed in users are redirected away from signup" do
    user = User.create!(name: "Existing", email: "existing@example.com", password: "password123", password_confirmation: "password123")

    post session_url, params: { session: { email: user.email, password: "password123" } }
    assert_redirected_to competitions_url

    get new_user_url
    assert_redirected_to profile_url
  end
end
