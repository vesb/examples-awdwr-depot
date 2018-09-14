class FreezeItemsInCartPrice < ActiveRecord::Migration[5.2]
  def up
    products_passed = {}
    Cart.all.each do |cart|
      cart.line_items.each do |line_item|
        if products_passed.key?(line_item.product_id)
          product_price = products_passed[line_item.product_id]
        else
          product = Product.find_by(id: line_item.product_id)
          product_price = product.price
          products_passed[line_item.product_id] = product_price
        end

        line_item.price = product_price
        line_item.save!
      end
    end
  end

  def down
    Cart.all.each do |cart|
      cart.line_items.each do |line_item|
        line_item.price = nil
        line_item.save!
      end
    end
  end
end
