class Product < ApplicationRecord

  has_many :line_items
  has_many :orders, through: :line_items

  before_destroy :ensure_not_referenced_by_any_line_item

  validates :description, presence: true, length: {
    minimum: 20,
    message: 'is too short for a product!'
  }
  validates :price, numericality: { greater_than_or_equal_to: 0.01 }
  validates :title, presence: true, uniqueness: true, length: { minimum: 15 }
  validates :image_url, presence: true, format: {
    with: %r{\.(gif|jpg|png)\Z}i,
    message: 'must be a URL for GIF, JPG or PNG image.'
  }

  private
    # ensure that there are no line items referencing this Product
    def ensure_not_referenced_by_any_line_item
      unless line_items.empty?
        errors.add(:base, 'Line Items present')
        throw :abort
      end
    end
end
