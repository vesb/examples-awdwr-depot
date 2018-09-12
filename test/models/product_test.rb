require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  fixtures :products

  test 'product attributes must not be empty' do
    product = Product.new

    assert product.invalid?

    assert product.errors[:title].any?
    assert product.errors[:description].any?
    assert product.errors[:image_url].any?
    assert product.errors[:price].any?

  end

  test 'product price must be positive' do
    product = Product.new(
      title: 'My book title shouldn\'t be short',
      description: 'This is some very fancy description of my book',
      image_url: 'fancy-image.gif'
    )

    product.price = -1
    assert product.invalid?
    assert_equal ['must be greater than or equal to 0.01'], product.errors[:price]

    product.price = 0
    assert product.invalid?
    assert_equal ['must be greater than or equal to 0.01'], product.errors[:price]

    product.price = 1
    assert product.valid?
  end

  test 'product has valid image url' do
    ok = %w{ a.gif b.jpg c.png A.JPG D.jPg http://a.b.c/x/y/z.gif }
    bad = %w{ a.doc b.pdf c.jpg/more d.jpg.ext }

    ok.each do |name|
      assert new_product_with_image(name).valid?, "#{name} shouldn't be invalid"
    end

    bad.each do |name|
      assert new_product_with_image(name).invalid?, "#{name} shouldn't be valid"
    end
  end

  test 'product is not valid without a unique title' do
    product = Product.new(
      title: products(:ruby).title,
      description: 'some fancy description',
      image_url: 'fency-image.gif',
      price: 1
    )

    assert product.invalid?
    assert_equal [I18n.translate('errors.messages.taken')], product.errors[:title]
  end

  test 'product title is too short' do
    product = Product.new(
      title: 'short title',
      description: 'some random description for title minimum length',
      image_url: 'fancy-image.gif',
      price: 1
    )

    assert product.invalid?
    assert_equal [I18n.translate('errors.messages.too_short.other', count: 15)], product.errors[:title]
  end

  test 'product description too short custom message' do
    product = Product.new(
      title: 'This title should be long enough',
      description: 'i\'m short',
      image_url: 'short-image.png',
      price: 1
    )

    assert product.invalid?
    assert_equal ['is too short for a product!'], product.errors[:description]
  end

  def new_product_with_image(image_url)
    Product.new(
      title: 'My book title shouldn\'t be short',
      description: 'Description for my book title while testing image url',
      image_url: image_url,
      price: 1
    )
  end
end
