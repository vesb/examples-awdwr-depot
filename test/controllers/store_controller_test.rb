require 'test_helper'

class StoreControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get store_index_url
    assert_response :success

    assert_select '#columns #side a', minimum: 4
    assert_select '#main .entry', Product.count
    assert_select 'h3', 'Here comes the second title'
    assert_select '.price', /\$\s[,\d]+\.\d\d/
  end

end
