require 'test_helper'

class ProductsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @product = products(:one)
    @valid_product = {
      title: 'Test Product long title',
      description: 'Test product\'s description goes here',
      image_url: 'test-product.jpg',
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

  test "should destroy product" do
    assert_difference('Product.count', -1) do
      delete product_url(@product)
    end

    assert_redirected_to products_url
  end

  test 'should desplay product layout' do
    get product_url(@product)
    assert_response :success

    assert_select '#columns #main p:nth-child(2) strong', 'Title:'
    assert_select '#columns #main p:nth-child(5) strong', 'Price:'
    assert_select '#columns #main p:nth-child(5)', /\$\s\d+\.\d+/
  end
end
