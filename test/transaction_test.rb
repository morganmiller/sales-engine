require_relative '../test/test_helper'
require_relative '../lib/transaction'
require_relative '../lib/sales_engine'

class TransactionTest < Minitest::Test

  def test_it_can_find_invoice
    engine = SalesEngine.new("./test/fixtures")
    engine.startup
    transaction = engine.transaction_repository.all[0]
    
    assert_equal 1, transaction.invoice.id
  end
end
