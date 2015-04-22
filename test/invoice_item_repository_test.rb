require_relative '../test/test_helper'
require_relative '../lib/invoice_item_repository'
require 'bigdecimal/util'

class InvoiceItemRepositoryTest < Minitest::Test

  def test_it_starts_with_an_empty_array_of_invoice_items
    invoice_item_repository = InvoiceItemRepository.new(nil)
    assert_equal [], invoice_item_repository.invoice_items
  end

  def test_it_can_load_data_to_invoice_item_repository
    invoice_item_repository = InvoiceItemRepository.new(nil)
    invoice_item_repository.load_data("./test/fixtures/invoice_items.csv")

    assert_equal 5 , invoice_item_repository.invoice_items.length
    assert_equal 539, invoice_item_repository.invoice_items.first.item_id
    assert_equal 1, invoice_item_repository.invoice_items.first.id
    assert_equal 523, invoice_item_repository.invoice_items[2].item_id
  end

  def test_it_can_return_all_invoice_items
    invoice_item_repository = InvoiceItemRepository.new(nil)
    invoice_item_repository.load_data("./test/fixtures/invoice_items.csv")
    result = invoice_item_repository.all.map {|invoice_item| invoice_item.id}

    assert_equal [1, 2, 3, 4, 5], result
  end

  def test_it_can_find_a_random_invoice_item
    invoice_item_repository = InvoiceItemRepository.new(nil)
    invoice_item_repository.load_data("./test/fixtures/invoice_items.csv")
    random_sample = invoice_item_repository.random

    assert random_sample.is_a?(InvoiceItem)
  end

  def test_it_can_find_an_invoice_item_by_id
    invoice_item_repository = InvoiceItemRepository.new(nil)
    invoice_item_repository.load_data("./test/fixtures/invoice_items.csv")

    assert_equal 539, invoice_item_repository.find_by_id(1).item_id
    assert_equal 1, invoice_item_repository.find_by_id(1).invoice_id
    assert_equal 528, invoice_item_repository.find_by_id(2).item_id
  end

  def test_it_can_find_an_invoice_items_invoice_id
    invoice_item_repository = InvoiceItemRepository.new(nil)
    invoice_item_repository.load_data("./test/fixtures/invoice_items.csv")

    assert_equal 1, invoice_item_repository.find_by_invoice_id(1).id
  end

  def test_it_can_find_an_invoice_items_by_item_id
    invoice_item_repository = InvoiceItemRepository.new(nil)
    invoice_item_repository.load_data("./test/fixtures/invoice_items.csv")

    assert_equal 1, invoice_item_repository.find_by_item_id(539).id
  end

  def test_it_can_find_an_invoice_items_quantity
    invoice_item_repository = InvoiceItemRepository.new(nil)
    invoice_item_repository.load_data("./test/fixtures/invoice_items.csv")

    assert_equal 1, invoice_item_repository.find_by_quantity(5).id
    assert_equal 3, invoice_item_repository.find_by_quantity(8).id
  end

  def test_it_can_find_by_unit_price
    invoice_item_repository = InvoiceItemRepository.new(nil)
    invoice_item_repository.load_data("./test/fixtures/invoice_items.csv")
    result = invoice_item_repository.find_by_unit_price(BigDecimal.new(13635)/100)

    assert_equal "136.35", result.unit_price.to_digits
  end

  def test_it_can_find_an_invoice_item_by_created_at_date
    invoice_item_repository = InvoiceItemRepository.new(nil)
    invoice_item_repository.load_data("./test/fixtures/invoice_items.csv")

    assert_equal 1, invoice_item_repository.find_by_created_at("2012-03-27 14:54:09 UTC").id
    assert_equal 539, invoice_item_repository.find_by_created_at("2012-03-27 14:54:09 UTC").item_id
  end

  def test_it_can_find_an_invoice_item_by_updated_at_date
    invoice_item_repository = InvoiceItemRepository.new(nil)
    invoice_item_repository.load_data("./test/fixtures/invoice_items.csv")

    assert_equal 1, invoice_item_repository.find_by_updated_at("2012-03-27 14:54:09 UTC").id
    assert_equal 539, invoice_item_repository.find_by_updated_at("2012-03-27 14:54:09 UTC").item_id
  end

  def test_it_can_find_all_invoice_items_by_id
    invoice_item_repository = InvoiceItemRepository.new(nil)
    invoice_item_repository.load_data("./test/fixtures/invoice_items.csv")

    assert_equal 539, invoice_item_repository.find_all_by_id(1)[0].item_id
    assert_equal 1, invoice_item_repository.find_all_by_id(1)[0].invoice_id
    assert_equal 528, invoice_item_repository.find_all_by_id(2)[0].item_id
  end

  def test_it_can_find_all_invoice_items_by_invoice_id
    invoice_item_repository = InvoiceItemRepository.new(nil)
    invoice_item_repository.load_data("./test/fixtures/invoice_items.csv")

    assert_equal 5, invoice_item_repository.find_all_by_invoice_id(1).count
  end

  def test_it_can_find_all_invoice_items_by_item_id
    invoice_item_repository = InvoiceItemRepository.new(nil)
    invoice_item_repository.load_data("./test/fixtures/invoice_items.csv")

    assert_equal 1, invoice_item_repository.find_all_by_item_id(539)[0].id
  end

  def test_it_can_find_all_invoice_items_by_quantity
    invoice_item_repository = InvoiceItemRepository.new(nil)
    invoice_item_repository.load_data("./test/fixtures/invoice_items.csv")

    assert_equal 1, invoice_item_repository.find_all_by_quantity(5)[0].id
    assert_equal 3, invoice_item_repository.find_all_by_quantity(8)[0].id
  end

  def test_it_can_find_all_invoice_items_by_unit_price
    invoice_item_repository = InvoiceItemRepository.new(nil)
    invoice_item_repository.load_data("./test/fixtures/invoice_items.csv")
    result = invoice_item_repository.find_all_by_unit_price(BigDecimal.new(13635)/100)

    assert_equal 1, result.count
  end

  def test_it_can_find_all_invoice_items_by_created_at_date
    invoice_item_repository = InvoiceItemRepository.new(nil)
    invoice_item_repository.load_data("./test/fixtures/invoice_items.csv")

    assert_equal 5, invoice_item_repository.find_all_by_created_at("2012-03-27 14:54:09 UTC").count
    assert_equal 0, invoice_item_repository.find_all_by_created_at("2012-03-27 14:54:10 UTC").count
  end

  def test_it_can_find_all_invoice_items_by_updated_at_date
    invoice_item_repository = InvoiceItemRepository.new(nil)
    invoice_item_repository.load_data("./test/fixtures/invoice_items.csv")

    assert_equal 5, invoice_item_repository.find_all_by_updated_at("2012-03-27 14:54:09 UTC").count
    assert_equal 0, invoice_item_repository.find_all_by_updated_at("2012-03-27 14:54:10 UTC").count
  end
end


#come back and figure out BigDecimal and unit_price and refactor
#what to_i are needed??? can it be in string format per spec harness
#also, figure out the requires and file paths can you just
#require_relative 'test_helper' ? do this at the end once you have the
#spec_harness attached
