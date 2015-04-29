require './test/test_helper'
require './lib/invoice'
require './lib/sales_engine'

class InvoiceTest < Minitest::Test
  attr_reader :invoice, :engine

  def setup
    @engine = SalesEngine.new("./test/fixtures")
    @engine.startup
    @invoice = engine.invoice_repository.all[0]
  end

  def test_it_can_find_transactions
    assert_equal 1, invoice.transactions.length
  end

  def test_it_can_find_invoice_items
    assert_equal 5, invoice.invoice_items.length
  end

  def test_it_can_find_customer
    assert_equal 1, invoice.customer.id
  end

  def test_it_can_find_merchant
    refute invoice.merchant
  end

  def test_it_can_find_items
    assert_equal 5, invoice.items.length
  end

  def test_it_can_do_a_new_charge_for_invoice
    assert_equal 1, invoice.charge(card_number: "4444333322221111").first.id
  end
end
