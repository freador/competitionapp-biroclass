require "test_helper"

class ProfilesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create!(name: "Profile User", email: "profile@example.com", password: "password123", password_confirmation: "password123")
  end

  test "should require authentication" do
    get profile_url
    assert_redirected_to new_session_url
  end

  test "should show profile when signed in" do
    sign_in_as(@user)

    get profile_url
    assert_response :success
  end

  test "should update profile" do
    sign_in_as(@user)

    patch profile_url, params: { user: { name: "Updated Name" } }
    assert_redirected_to profile_url
    @user.reload
    assert_equal "Updated Name", @user.name
  end

  private

  def sign_in_as(user)
    post session_url, params: { session: { email: user.email, password: "password123" } }
  end
end
