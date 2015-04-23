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
    engine = SalesEngine.new("./data")
    engine.startup
    merchant = engine.merchant_repository.find_by_name("Terry-Moore")

    assert merchant.favorite_customer.is_a?(Customer)
    assert_equal "Jayme", merchant.favorite_customer.first_name
  end

  def test_transactions_hash_is_removing_successful_transactions
    engine = SalesEngine.new("./data")
    engine.startup
    merchant = engine.merchant_repository.find_by_name("Parisian Group")

    assert_equal 2, merchant.customers_with_pending_invoices.length
    assert merchant.customers_with_pending_invoices[0].is_a?(Customer)
    assert_equal "Kailee", merchant.customers_with_pending_invoices[0].first_name
  end
end
