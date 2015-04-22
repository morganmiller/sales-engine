require_relative '../test/test_helper'
require_relative '../lib/customer'
require_relative '../lib/sales_engine'

class CustomerTest < Minitest::Test
  attr_reader :data

  # def setup
  #   @data =   {
  #               id:         "1",
  #               first_name: "Joey",
  #               last_name:  "Ondricka",
  #               created_at: "2012-03-27 14:54:09 UTC",
  #               updated_at: "2012-03-27 14:54:09 UTC"
  #             }
  # end


  # def test_it_has_the_expected_initialized_id
  #   customer = Customer.new(data, nil)
  #
  #   assert 1, customer.id
  # end

  def test_it_can_find_invoices
    engine = SalesEngine.new("./test/fixtures")
    engine.startup
    customer = engine.customer_repository.all[0]
    assert_equal 5, customer.invoices.length
  end

end
