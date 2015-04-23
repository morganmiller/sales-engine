require_relative '../test/test_helper'
require_relative '../lib/item'
require_relative '../lib/sales_engine'

class ItemTest < Minitest::Test

  def test_it_can_find_invoice_items
    engine = SalesEngine.new("./test/fixtures")
    engine.startup
    item = engine.item_repository.all[0]

    assert_equal 0, item.invoice_items.length
  end

  def test_it_can_find_merchant_by_merchant_id
    engine = SalesEngine.new("./test/fixtures")
    engine.startup
    item = engine.item_repository.all[0]
    
    assert_equal 1, item.merchant.id
  end
end
