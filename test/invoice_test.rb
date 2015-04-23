require_relative '../test/test_helper'
require_relative '../lib/invoice'
require_relative '../lib/sales_engine'

class InvoiceTest < Minitest::Test

  def test_it_can_find_transactions
    engine = SalesEngine.new("./test/fixtures")
    engine.startup
    invoice = engine.invoice_repository.all[0]

    assert_equal 1, invoice.transactions.length
  end

  def test_it_can_find_invoice_items
    engine = SalesEngine.new("./test/fixtures")
    engine.startup
    invoice = engine.invoice_repository.all[0]

    assert_equal 5, invoice.invoice_items.length
  end

  def test_it_can_find_customer
    engine = SalesEngine.new("./test/fixtures")
    engine.startup
    invoice = engine.invoice_repository.all[0]

    assert_equal 1, invoice.customer.id
  end

  def test_it_can_find_merchant
    engine = SalesEngine.new("./test/fixtures")
    engine.startup
    invoice = engine.invoice_repository.all[0]
    
    refute invoice.merchant
  end

  def test_it_can_find_items
    engine = SalesEngine.new("./test/fixtures")
    engine.startup
    invoice = engine.invoice_repository.all[0]

    assert_equal 5, invoice.items.length
    assert_equal "", invoice.items
  end
end
