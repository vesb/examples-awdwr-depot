require 'test_helper'

class LineItemsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @line_item = line_items(:one_in_cart_one)
  end

  test "should get index" do
    get line_items_url
    assert_response :success
  end

  test "should get new" do
    get new_line_item_url
    assert_response :success
  end

  test "should create line_item" do
    assert_difference('LineItem.count') do
      post line_items_url, params: { product_id: products(:ruby).id }
    end

    follow_redirect!

    assert_select '#side h2', 'Your Cart'
    assert_select '#side table tr td:nth-child(2)', 'Programming Ruby 1.9'
  end

  test "should add unique line_items in cart" do
    assert_difference('LineItem.count', +2) do
      post line_items_url, params: { product_id: products(:one).id }
      post line_items_url, params: { product_id: products(:two).id }
    end

    follow_redirect!

    assert_select '#side h2', 'Your Cart'
    assert_select '#side table tr:nth-child(1) td:nth-child(1)', "1\u00D7"
    assert_select '#side table tr:nth-child(1) td:nth-child(2)', products(:one).title
    assert_select '#side table tr:nth-child(2) td:nth-child(1)', "1\u00D7"
    assert_select '#side table tr:nth-child(2) td:nth-child(2)', products(:two).title
  end

  test "should add duplicate line_items in cart" do
    assert_difference('LineItem.count', +1) do
      post line_items_url, params: { product_id: products(:one).id }
      post line_items_url, params: { product_id: products(:one).id }
    end

    follow_redirect!

    assert_select '#side h2', 'Your Cart'
    assert_select '#side table tr:nth-child(1) td:nth-child(1)', "2\u00D7"
    assert_select '#side table tr:nth-child(1) td:nth-child(2)', products(:one).title
  end

  test "should show line_item" do
    get line_item_url(@line_item)
    assert_response :success
  end

  test "should get edit" do
    get edit_line_item_url(@line_item)
    assert_response :success
  end

  test "should update line_item" do
    patch line_item_url(@line_item), params: { line_item: { product_id: @line_item.product_id } }
    assert_redirected_to line_item_url(@line_item)
  end

  test "should destroy line_item and redirect to store_index_url" do
    post line_items_url, params: { product_id: products(:one).id }
    @line_item = LineItem.find_by(cart_id: session[:cart_id], product_id: products(:one).id)

    assert_difference('LineItem.count', -1) do
      delete line_item_url(@line_item)
    end

    assert_redirected_to store_index_url
  end

  test "should destroy line_item and redirect to cart" do
    post line_items_url, params: { product_id: products(:one).id }
    post line_items_url, params: { product_id: products(:two).id }
    @line_item = LineItem.find_by(cart_id: session[:cart_id], product_id: products(:one).id)

    assert_difference('LineItem.count', -1) do
      delete line_item_url(@line_item)
    end

    assert_redirected_to @line_item.cart
  end

  test "should not destroy line_item in others cart" do
    post line_items_url, params: { product_id: products(:one).id }
    @line_item = LineItem.find_by(cart_id: session[:cart_id] - 1, product_id: products(:one).id)

    assert_difference('LineItem.count', 0) do
      delete line_item_url(@line_item)
    end

    assert_redirected_to @line_item.cart
  end
end
