require 'test_helper'

class ProductsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @product = products(:one)
    @product_not_in_cart = products(:not_in_cart)
    @valid_product = {
      title: 'Test Product long title',
      description: 'Test product\'s description goes here',
      image_url: 'ruby.jpg',
      price: 19.95
    }
  end

  test "should get index" do
    get products_url
    assert_response :success
  end

  test "should get new" do
    get new_product_url
    assert_response :success
  end

  test "should create product" do
    assert_difference('Product.count') do
      post products_url, params: { product: @valid_product }
    end

    assert_redirected_to product_url(Product.last)
  end

  test "should show product" do
    get product_url(@product)
    assert_response :success
  end

  test "should get edit" do
    get edit_product_url(@product)
    assert_response :success
  end

  test "should update product" do
    patch product_url(@product), params: { product: @valid_product }
    assert_redirected_to product_url(@product)
  end

  test "can't delete product which is already in someone's cart" do
    assert_difference('Product.count', 0) do
      delete product_url(products(:two))
    end

    assert_redirected_to products_url
  end

  test "should destroy product not in cart" do
    assert_difference('Product.count', -1) do
      delete product_url(@product_not_in_cart)
    end

    assert_redirected_to products_url
  end

  test "should not destroy product in cart" do
    assert_difference('Product.count', 0) do
      delete product_url(@product)
    end

    assert_redirected_to products_url
  end

  test "should display product layout" do
    get product_url(@product)
    assert_response :success

    assert_select '#columns #main p:nth-child(2) strong', 'Title:'
    assert_select '#columns #main p:nth-child(5) strong', 'Price:'
    assert_select '#columns #main p:nth-child(5)', /\$\s\d+\.\d+/
  end
end
