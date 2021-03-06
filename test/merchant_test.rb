require_relative '../test/test_helper'
require_relative '../lib/merchant'
require_relative '../lib/sales_engine'

class MerchantTest < Minitest::Test

  def test_it_can_find_items
    engine = SalesEngine.new("./test/fixtures")
    engine.startup
    merchant = engine.merchant_repository.all[0]
    
    assert_equal 5, merchant.items.length
  end

  def test_it_can_find_invoices
    engine = SalesEngine.new("./test/fixtures")
    engine.startup
    merchant = engine.merchant_repository.all[0]

    assert_equal 0, merchant.invoices.length
  end

  def test_it_can_find_customer_with_most_transactions
    engine = SalesEngine.new("./test/business_logic_fixtures")
    engine.startup
    merchant = engine.merchant_repository.all[0]

    assert merchant.favorite_customer.is_a?(Customer)
    assert_equal "Joey", merchant.favorite_customer.first_name
  end

  def test_transactions_hash_is_removing_successful_transactions
    engine = SalesEngine.new("./test/business_logic_fixtures")
    engine.startup
    merchant = engine.merchant_repository.all[0]

    assert_equal 0, merchant.customers_with_pending_invoices.length
  end

  def test_it_can_find_revenue_without_date
    engine = SalesEngine.new("./test/business_logic_fixtures")
    engine.startup
    merchant = engine.merchant_repository.all[0]

    assert_equal 18599, merchant.revenue.to_i
  end


  def test_it_can_find_revenue_with_date
    engine = SalesEngine.new("./test/business_logic_fixtures")
    engine.startup
    merchant = engine.merchant_repository.all[0]
    date = Date.new(2012, 3, 25)

    assert_equal 13660, merchant.revenue(date).to_i
  end
end
