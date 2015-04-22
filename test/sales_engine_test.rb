require_relative '../test/test_helper'
require_relative '../lib/sales_engine'

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
    # engine.customer_repository.load_data("#{@filepath}/customers.csv")


    refute engine.customer_repository.customers.empty?
    refute engine.merchant_repository.merchants.empty?
    refute engine.invoice_repository.invoices.empty?
    refute engine.invoice_item_repository.invoice_items.empty?
    refute engine.item_repository.items.empty?
    refute engine.transaction_repository.transactions.empty?
  end








end
