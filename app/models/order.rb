class Order < ApplicationRecord
  has_many :line_items, dependent: :destroy

  validates :name, :address, :email, presence: true
  validates :payment_type, inclusion: {
    in: PaymentType.all.map { |payment_type| payment_type.id }
  }

  def add_line_items_from_cart(cart)
    cart.line_items.each do |item|
      item.cart_id = nil
      line_items << item
    end
  end

  def available_payment_types
    if @available_payment_types.nil?
      @available_payment_types = PaymentType.all.map { |payment_type|
        [payment_type.name, payment_type.id]
      }.to_h
    end

    @available_payment_types
  end
end
