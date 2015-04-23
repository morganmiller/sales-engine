require_relative '../test/test_helper'
require_relative '../lib/transaction_repository'

class TransactionRepositoryTest < Minitest::Test

  def test_it_starts_with_an_empty_array_of_transactions
    transaction_repository = TransactionRepository.new(nil)

    assert_equal [], transaction_repository.transactions
  end

  def test_it_can_load_data_to_transaction
    transaction_repository = TransactionRepository.new(nil)
    transaction_repository.load_data("./test/fixtures/transactions.csv")

    assert_equal 5 , transaction_repository.transactions.length
    assert_equal 1, transaction_repository.transactions.first.id
    assert_equal 4354495077693036, transaction_repository.transactions[2].credit_card_number
  end

  def test_it_can_return_all_transactions
    transaction_repository = TransactionRepository.new(nil)
    transaction_repository.load_data("./test/fixtures/transactions.csv")
    result = transaction_repository.all.map {|transaction| transaction.id}

    assert_equal [1, 2, 3, 4, 5], result
  end

  def test_it_can_find_a_random_transaction
    transaction_repository = TransactionRepository.new(nil)
    transaction_repository.load_data("./test/fixtures/transactions.csv")
    random_sample = transaction_repository.random

    assert random_sample.is_a?(Transaction)
  end

  def test_it_can_find_a_transaction_by_id
    transaction_repository = TransactionRepository.new(nil)
    transaction_repository.load_data("./test/fixtures/transactions.csv")

    assert_equal 4654405418249632, transaction_repository.find_by_id(1).credit_card_number
    assert_equal 1, transaction_repository.find_by_id(1).invoice_id
    assert_equal 4580251236515201, transaction_repository.find_by_id(2).credit_card_number
  end

  def test_it_can_find_a_transaction_by_invoice_id
    transaction_repository = TransactionRepository.new(nil)
    transaction_repository.load_data("./test/fixtures/transactions.csv")

    assert_equal 4654405418249632, transaction_repository.find_by_invoice_id(1).credit_card_number
    assert_equal 1, transaction_repository.find_by_invoice_id(1).id
    assert_equal 4580251236515201, transaction_repository.find_by_invoice_id(2).credit_card_number
  end

  def test_it_can_find_a_transaction_by_credit_card_number
    transaction_repository = TransactionRepository.new(nil)
    transaction_repository.load_data("./test/fixtures/transactions.csv")

    assert_equal 1, transaction_repository.find_by_credit_card_number(4654405418249632).id
    assert_equal 2, transaction_repository.find_by_credit_card_number(4580251236515201).invoice_id
    assert_equal "success", transaction_repository.find_by_credit_card_number(4515551623735607).result
  end

  def test_it_can_find_a_transaction_by_credit_expiration_date
    skip #credit card expiration date is empty...what will we do here?
    transaction_repository = TransactionRepository.new(nil)
    transaction_repository.load_data("./test/fixtures/transactions.csv")
  end

  def test_it_can_find_a_transaction_by_created_at_date
    transaction_repository = TransactionRepository.new(nil)
    transaction_repository.load_data("./test/fixtures/transactions.csv")

    assert_equal 1, transaction_repository.find_by_created_at("2012-03-27 14:54:09 UTC").id
    assert_equal 3, transaction_repository.find_by_created_at("2012-03-27 14:54:10 UTC").id
  end

  def test_it_can_find_a_transaction_by_updated_at_date
    transaction_repository = TransactionRepository.new(nil)
    transaction_repository.load_data("./test/fixtures/transactions.csv")

    assert_equal 1, transaction_repository.find_by_updated_at("2012-03-27 14:54:09 UTC").id
    assert_equal 3, transaction_repository.find_by_updated_at("2012-03-27 14:54:10 UTC").id
  end

  def test_it_can_find_a_transaction_by_result
    transaction_repository = TransactionRepository.new(nil)
    transaction_repository.load_data("./test/fixtures/transactions.csv")

    assert_equal 1, transaction_repository.find_by_result("success").id
  end

  def test_it_can_find_all_transactions_by_id
    transaction_repository = TransactionRepository.new(nil)
    transaction_repository.load_data("./test/fixtures/transactions.csv")

    assert_equal 1, transaction_repository.find_all_by_id(1).count
    assert transaction_repository.find_all_by_id(1)[0].is_a?(Transaction)
  end

  def test_it_can_find_all_transactions_by_invoice_id
    transaction_repository = TransactionRepository.new(nil)
    transaction_repository.load_data("./test/fixtures/transactions.csv")

    assert_equal 1, transaction_repository.find_all_by_invoice_id(1).count
    assert transaction_repository.find_all_by_invoice_id(4)[0].is_a?(Transaction)
  end

  def test_it_can_find_all_transactions_by_credit_card_number
    transaction_repository = TransactionRepository.new(nil)
    transaction_repository.load_data("./test/fixtures/transactions.csv")

    assert_equal 1, transaction_repository.find_all_by_credit_card_number(4654405418249632).count
    assert_equal 2, transaction_repository.find_all_by_credit_card_number(4580251236515201)[0].invoice_id
    assert_equal "success", transaction_repository.find_all_by_credit_card_number(4515551623735607)[0].result
  end

  def test_it_can_find_all_transactions_by_credit_expiration_date
    skip #credit card expiration date is empty...what will we do here?
    transaction_repository = TransactionRepository.new(nil)
    transaction_repository.load_data("./test/fixtures/transactions.csv")
  end

  def test_it_can_find_all_transactions_by_created_at_date
    transaction_repository = TransactionRepository.new(nil)
    transaction_repository.load_data("./test/fixtures/transactions.csv")

    assert_equal 2, transaction_repository.find_all_by_created_at("2012-03-27 14:54:09 UTC").count
    assert_equal 3, transaction_repository.find_all_by_created_at("2012-03-27 14:54:10 UTC").count
    assert transaction_repository.find_all_by_created_at("2012-03-27 14:54:10 UTC")[0].is_a?(Transaction)
  end

  def test_it_can_find_all_transactions_by_updated_at_date
    transaction_repository = TransactionRepository.new(nil)
    transaction_repository.load_data("./test/fixtures/transactions.csv")

    assert_equal 2, transaction_repository.find_all_by_updated_at("2012-03-27 14:54:09 UTC").count
    assert_equal 3, transaction_repository.find_all_by_updated_at("2012-03-27 14:54:10 UTC").count
    assert transaction_repository.find_all_by_updated_at("2012-03-27 14:54:10 UTC")[0].is_a?(Transaction)
  end

  def test_it_can_find_all_transactions_by_result
    transaction_repository = TransactionRepository.new(nil)
    transaction_repository.load_data("./test/fixtures/transactions.csv")

    assert_equal 5, transaction_repository.find_all_by_result("success").count
  end
end
