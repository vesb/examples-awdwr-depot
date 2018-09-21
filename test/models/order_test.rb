require 'test_helper'

class OrderTest < ActiveSupport::TestCase
    test 'order must not have invalid payment_type' do
      order = Order.new(
          name: 'First Order',
          address: 'MyText',
          email: 'first.order@example.org',
          payment_type: 2
      )

      assert order.invalid?

      assert order.errors[:payment_type].any?

    end
end
