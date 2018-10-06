require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
  end

  test "should get index" do
    get users_url
    assert_response :success
  end

  test "should get new" do
    get new_user_url
    assert_response :success
  end

  test "should create user" do
    assert_difference('User.count') do
      post users_url, params: { user: { name: 'unique', password: 'secret', password_confirmation: 'secret' } }
    end

    assert_redirected_to
  end

  test "should show user" do
    get user_url(@user)
    assert_response :success
  end

  test "should get edit" do
    get edit_user_url(@user)
    assert_response :success
  end

  test "should update user" do
    other_user = users(:two)
    patch user_url(other_user),
      params: {
        user: {
          name: other_user.name,
          password: 'secret1',
          password_confirmation: 'secret1',
          current_password: 'secret'
        }
      }
    assert_redirected_to users_url
  end

  test "should update current user after valid current password" do
    patch user_url(@user),
      params: {
        user: {
          name: @user.name,
          password: 'secret1',
          password_confirmation: 'secret1',
          current_password: 'secret'
        }
      }
    assert_redirected_to users_url
  end

  test "should not update current user after invalid current password" do
    patch user_url(@user),
      params: {
        user: {
          name: @user.name,
          password: 'secret1',
          password_confirmation: 'secret1',
          current_password: 'not-valid-secret'
        }
      }
    assert_redirected_to edit_user_url(@user)
  end

  test "should destroy user" do
    assert_difference('User.count', -1) do
      delete user_url(@user)
    end

    assert_redirected_to users_url
    assert_equal flash[:notice], 'User was successfully destroyed.'
  end

  test 'should not destroy the last user' do
    delete user_url(users(:two))

    assert_difference('User.count', 0) do
      delete user_url(users(:one))

      assert_redirected_to users_url
      assert_equal flash[:notice], 'Can not delete the last user.'
    end
  end
end
