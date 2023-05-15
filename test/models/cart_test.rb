require 'test_helper'

class CartTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test "adding unique product should increase cart size by 1" do
    cart = carts(:one)
    product = products(:ruby)
    assert_difference('cart.line_items.count', 1) do
      cart.add_product(product)
    end
  end

  test "adding duplicate product should not increase cart size" do
    cart = carts(:one)
    product = products(:ruby)
    cart.add_product(product)
    assert_no_difference('cart.line_items.count') do
      cart.add_product(product)
    end
  end
end
