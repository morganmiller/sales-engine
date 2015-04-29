require './test/test_helper'
require './lib/item'
require './lib/sales_engine'

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

  def test_it_can_find_best_day
    engine = SalesEngine.new("./test/business_logic_fixtures")
    engine.startup
    item = engine.item_repository.all[0]

    assert_equal Date.new(2012,3,25), item.best_day
  end
end
