require_relative '../test/test_helper'
require_relative '../lib/invoice_item'
require_relative '../lib/sales_engine'

class InvoiceItemTest < Minitest::Test

  def test_it_can_find_invoice
    engine = SalesEngine.new("./test/fixtures")
    engine.startup
    invoice_item = engine.invoice_item_repository.all[0]
    assert_equal 1, invoice_item.invoice.id
  end

  def test_it_can_find_item
    engine = SalesEngine.new("./test/fixtures")
    engine.startup
    invoice_item = engine.invoice_item_repository.all[0]
    refute invoice_item.item
  end
end
