require './test/test_helper'
require './lib/sales_engine'

class SalesEngineTest < Minitest::Test

  attr_reader :engine

  def setup
    @engine = SalesEngine.new("test/fixtures")
    @engine.startup
    unless @engine
      @engine
    end
  end

  def test_startup_creates_new_repositories
    assert engine.customer_repository
    assert engine.merchant_repository
    assert engine.invoice_repository
    assert engine.invoice_item_repository
    assert engine.item_repository
    assert engine.transaction_repository
  end

  def test_it_knows_repository_relationships_with_class
    assert engine.customer_repository.find_by_id(4).is_a?(Customer)
    assert engine.merchant_repository.find_by_id(2).is_a?(Merchant)
    assert engine.invoice_repository.find_by_id(1).is_a?(Invoice)
    assert engine.invoice_item_repository.find_by_id(2).is_a?(InvoiceItem)
    assert engine.item_repository.find_by_id(2).is_a?(Item)
    assert engine.transaction_repository.find_by_id(2).is_a?(Transaction)
  end

  def test_it_knows_filepath
    assert_equal "test/fixtures", engine.filepath
  end

  def test_it_can_load_data_at_startup
    refute engine.customer_repository.customers.empty?
    refute engine.merchant_repository.merchants.empty?
    refute engine.invoice_repository.invoices.empty?
    refute engine.invoice_item_repository.invoice_items.empty?
    refute engine.item_repository.items.empty?
    refute engine.transaction_repository.transactions.empty?
  end

  def test_it_can_find_invoices_by_customer_id
    assert_equal 5, engine.find_invoices_by_customer_id(1).length
  end

  def test_it_can_find_invoice_by_id
    assert_equal 1, engine.find_invoice_by_invoice_id(1).id
  end

  def test_it_can_find_items_by_merchant_id
    assert_equal 5, engine.find_items_by_merchant_id(1).length
  end

  def test_it_can_find_invoices_by_merchant_id
    assert_equal 1, engine.find_invoices_by_merchant_id(26).length
  end

  def test_it_can_find_invoice_items_by_item_id
    assert_equal 1, engine.find_invoice_items_by_item_id(539).length
  end

  def test_it_can_find_merchant_by_id
    assert_equal 1, engine.find_merchant_by_id(1).id
  end

  def test_it_can_find_item_by_id
    assert_equal 1, engine.find_item_by_id(1).id
  end

  def test_it_can_find_transactions_by_invoice_id
    assert_equal 1, engine.find_transactions_by_invoice_id(1).length
  end

  def test_it_can_find_invoice_items_by_invoice_id
    assert_equal 5, engine.find_invoice_items_by_invoice_id(1).length
  end

  def test_it_can_find_customer_by_id
    assert_equal 1, engine.find_customer_by_id(1).id
  end

  def test_it_can_find_items_by_ids
    assert engine.find_items_by_ids([1,2,3,4,5])[0].is_a?(Item)
    assert_equal 5, engine.find_items_by_ids([1,2,3,4,5]).length
  end

  def test_it_can_find_most_items_sold
    sales_engine = SalesEngine.new("./test/business_logic_fixtures")
    sales_engine.startup

    assert_equal "Item Qui Esse", sales_engine.find_most_items(2).last.name
  end

  def test_it_can_find_top_grossing_items
    sales_engine = SalesEngine.new("./test/business_logic_fixtures")
    sales_engine.startup

    assert_equal "Item Autem Minima", sales_engine.find_most_revenue_for_items(3).first.name
  end

  def test_it_can_find_total_revenue_for_a_merchant_with_no_date
    sales_engine = SalesEngine.new("./test/business_logic_fixtures")
    sales_engine.startup

    assert_equal 18599, sales_engine.merchant_repository.total_revenue_for_a_merchant(1).to_i
  end

  def test_it_can_find_total_revenue_for_a_merchant_with_date
    engine = SalesEngine.new("./test/business_logic_fixtures")
    engine.startup
    merchant = engine.merchant_repository.all[0]
    date = Date.new(2012, 3, 25)

    assert_equal 13660, merchant.revenue(date).to_i
  end

  def test_it_finds_all_merchant_revenue_by_date
    sales_engine = SalesEngine.new("./test/business_logic_fixtures")
    sales_engine.startup
    date = Date.new(2012, 3, 25)

    assert_equal 13660, sales_engine.merchant_repository.revenue(date).to_i
  end

  def test_item_knows_its_best_day
    sales_engine = SalesEngine.new("./test/business_logic_fixtures")
    sales_engine.startup
    item = sales_engine.item_repository.all[0]

    assert_equal Date.new(2012, 3, 25), item.best_day
  end
end

