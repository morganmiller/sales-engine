require_relative '../test/test_helper'
require_relative '../lib/invoice_repository'

class InvoiceRepositoryTest < Minitest::Test

  def test_it_starts_with_an_empty_array_of_invoices
    invoice_repository = InvoiceRepository.new(nil)
    assert_equal [], invoice_repository.invoices
  end

  def test_it_can_load_data_to_invoice
    invoice_repository = InvoiceRepository.new(nil)
    invoice_repository.load_data("./test/fixtures/invoices.csv")

    assert_equal 5 , invoice_repository.invoices.length
    assert_equal 1, invoice_repository.invoices.first.customer_id
    assert_equal 1, invoice_repository.invoices.first.id
    assert_equal 78, invoice_repository.invoices[2].merchant_id
  end

  def test_it_can_return_all_invoices
    invoice_repository = InvoiceRepository.new(nil)
    invoice_repository.load_data("./test/fixtures/invoices.csv")
    result = invoice_repository.all.map {|invoice| invoice.id}

    assert_equal [1, 2, 3, 4, 5], result
  end

  def test_it_can_find_a_random_invoice
    invoice_repository = InvoiceRepository.new(nil)
    invoice_repository.load_data("./test/fixtures/invoices.csv")
    random_sample = invoice_repository.random

    assert random_sample.is_a?(Invoice)
  end

  def test_it_can_find_a_invoice_by_id
    invoice_repository = InvoiceRepository.new(nil)
    invoice_repository.load_data("./test/fixtures/invoices.csv")

    assert_equal 1, invoice_repository.find_by_id(1).customer_id
    assert_equal 26, invoice_repository.find_by_id(1).merchant_id
    assert_equal 1, invoice_repository.find_by_id(2).customer_id
  end

  def test_it_can_find_a_invoice_by_customer_id
    invoice_repository = InvoiceRepository.new(nil)
    invoice_repository.load_data("./test/fixtures/invoices.csv")

    assert_equal 26, invoice_repository.find_by_customer_id(1).merchant_id
    assert_equal 1, invoice_repository.find_by_customer_id(1).id
  end

  def test_it_can_find_a_invoice_by_merchant_id
    invoice_repository = InvoiceRepository.new(nil)
    invoice_repository.load_data("./test/fixtures/invoices.csv")

    assert_equal 1, invoice_repository.find_by_merchant_id(26).customer_id
    assert_equal 2, invoice_repository.find_by_merchant_id(75).id
  end

  def test_it_can_find_a_invoice_by_status
    invoice_repository = InvoiceRepository.new(nil)
    invoice_repository.load_data("./test/fixtures/invoices.csv")

    assert_equal 1, invoice_repository.find_by_status("shipped").customer_id
    assert_equal 1, invoice_repository.find_by_status("shipped").id
  end

  def test_it_can_find_a_invoice_by_created_at_date
    invoice_repository = InvoiceRepository.new(nil)
    invoice_repository.load_data("./test/fixtures/invoices.csv")

    assert_equal 26, invoice_repository.find_by_created_at("2012-03-25 09:54:09 UTC").merchant_id
    assert_equal 1, invoice_repository.find_by_created_at("2012-03-25 09:54:09 UTC").id
  end

  def test_it_can_find_a_invoice_by_updated_at_date
    invoice_repository = InvoiceRepository.new(nil)
    invoice_repository.load_data("./test/fixtures/invoices.csv")

    assert_equal 26, invoice_repository.find_by_updated_at("2012-03-25 09:54:09 UTC").merchant_id
    assert_equal 1, invoice_repository.find_by_updated_at("2012-03-25 09:54:09 UTC").id
  end

  def test_it_can_find_all_invoices_by_id
    invoice_repository = InvoiceRepository.new(nil)
    invoice_repository.load_data("./test/fixtures/invoices.csv")
    result   = invoice_repository.find_all_by_id(1)
    result_2 = invoice_repository.find_all_by_id(2)

    assert_equal 26, result[0].merchant_id
    assert_equal 75, result_2[0].merchant_id
  end

  def test_it_can_find_all_invoices_by_customer_id
    invoice_repository = InvoiceRepository.new(nil)
    invoice_repository.load_data("./test/fixtures/invoices.csv")
    result   = invoice_repository.find_all_by_customer_id(1)
    result_2 = invoice_repository.find_all_by_customer_id(1)

    assert_equal 1, result[0].id
    assert_equal 1, result_2[0].id
  end

  def test_it_can_find_all_invoices_by_merchant_id
    invoice_repository = InvoiceRepository.new(nil)
    invoice_repository.load_data("./test/fixtures/invoices.csv")

    result   = invoice_repository.find_all_by_merchant_id(26)
    result_2 = invoice_repository.find_all_by_merchant_id(75)

    assert_equal 1, result[0].id
    assert_equal 2, result_2[0].id
  end

  def test_it_can_find_all_invoices_by_status
    invoice_repository = InvoiceRepository.new(nil)
    invoice_repository.load_data("./test/fixtures/invoices.csv")
    result   = invoice_repository.find_all_by_status("shipped")
    result_2 = invoice_repository.find_all_by_status("shipped")

    assert_equal 26, result[0].merchant_id
    assert_equal 1, result_2[0].customer_id
  end

  def test_it_can_find_all_invoices_by_created_at_date
    invoice_repository = InvoiceRepository.new(nil)
    invoice_repository.load_data("./test/fixtures/invoices.csv")

    assert_equal 1, invoice_repository.find_all_by_created_at("2012-03-25 09:54:09 UTC").count
    assert_equal 1, invoice_repository.find_all_by_created_at("2012-03-24 15:54:10 UTC").count
  end

  def test_it_can_find_all_invoices_by_updated_at_date
    invoice_repository = InvoiceRepository.new(nil)
    invoice_repository.load_data("./test/fixtures/invoices.csv")

    assert_equal 1, invoice_repository.find_all_by_updated_at("2012-03-25 09:54:09 UTC").count
    assert_equal 1, invoice_repository.find_all_by_updated_at("2012-03-12 05:54:09 UTC").count
  end
end
