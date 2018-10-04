require 'test_helper'

class UserStoriesTest < ActionDispatch::IntegrationTest
  fixtures :products, :payment_types
  include ActiveJob::TestHelper

  test 'user can create orders' do
    current_order_count = Order.count
    ruby_book = products(:ruby)

    get '/'
    assert_response :success
    assert_select 'h1', 'Your Pragmatic Catalog'

    post '/line_items', params: { product_id: ruby_book.id }, xhr: true
    assert_response :success

    cart = Cart.find(session[:cart_id])
    assert_equal 1, cart.line_items.size
    assert_equal ruby_book, cart.line_items[0].product

    get '/orders/new'
    assert_response :success
    assert_select 'legend', 'Please Enter Your Details'

    order_params = {
      name: 'First Last',
      address: 'Order address',
      email: 'test-order@example.com',
      payment_type: payment_types(:one).id,
    }
    perform_enqueued_jobs do
      post '/orders', params: {
        order: order_params
      }

      follow_redirect!

      assert_response :success
      assert_select 'h1', 'Your Pragmatic Catalog'
      cart = Cart.find(session[:cart_id])
      assert_equal 0, cart.line_items.size

      assert_equal current_order_count + 1, Order.count
      order = Order.last

      assert_equal 'First Last', order.name
      assert_equal 'Order address', order.address
      assert_equal 'test-order@example.com', order.email
      assert_equal payment_types(:one).id, order.payment_type

      assert_equal 1, order.line_items.size
      line_item = order.line_items[0]
      assert_equal ruby_book, line_item.product

      mail = ActionMailer::Base.deliveries.last
      assert_equal ['test-order@example.com'], mail.to
      assert_equal(
        'Awdwr Depot Application <awdwr.depot@example.com>',
        mail[:from].value
      )
      assert_equal 'Pragmatic Store Order Confirmation', mail.subject
    end
  end
end
