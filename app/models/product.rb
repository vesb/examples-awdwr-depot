class Product < ApplicationRecord
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
end
