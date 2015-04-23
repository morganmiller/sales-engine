require_relative '../test/test_helper'
require_relative '../lib/customer'
require_relative '../lib/sales_engine'

class CustomerTest < Minitest::Test

  def test_it_can_find_invoices
    engine = SalesEngine.new("./test/fixtures")
    engine.startup
    customer = engine.customer_repository.all[0]
    assert_equal 5, customer.invoices.length
  end

end
