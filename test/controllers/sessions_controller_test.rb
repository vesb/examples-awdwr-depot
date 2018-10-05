require 'test_helper'

class SessionsControllerTest < ActionDispatch::IntegrationTest
  test "should prompt for login" do
    get login_url
    assert_response :success
  end

  test 'should login' do
    user_one = users(:one)
    post login_url, params: { name: user_one.name, password: 'secret'}

    assert_redirected_to admin_url
    assert_equal user_one.id, session[:user_id]
  end

  test 'should fail to login' do
    user_one = users(:one)
    post login_url, params: { name: user_one.name, password: 'asd'}

    assert_redirected_to login_url
    assert_nil session[:user_id]
  end

  test "should logout" do
    delete logout_url

    assert_redirected_to store_index_url
    assert_nil session[:user_id]
  end

end
