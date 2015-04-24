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

  def test_it_can_find_invoices
    engine = SalesEngine.new("./test/fixtures")
    engine.startup
    customer = engine.customer_repository.all[0]

    assert_equal 5, customer.invoices.length
  end

  def test_it_can_find_transactions_by_invoices
    engine = SalesEngine.new("./test/fixtures")
    engine.startup
    customer = engine.customer_repository.all[0]

    assert customer.transactions[0].is_a?(Transaction)
    assert_equal 4 , customer.transactions.length
  end

  def test_it_can_find_successful_customer_transactions
    engine = SalesEngine.new("./data")
    engine.startup
    customer = engine.customer_repository.find_by_id(80)

    assert_equal 10, customer.transactions.length
    assert_equal 9 , customer.successful_customer_transactions.length
  end
end
