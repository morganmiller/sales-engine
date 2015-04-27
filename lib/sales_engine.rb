require_relative './customer_repository'
require_relative './merchant_repository'
require_relative './invoice_repository'
require_relative './invoice_item_repository'
require_relative './item_repository'
require_relative './transaction_repository'
require 'pry'

class SalesEngine
  attr_reader :customer_repository,
              :merchant_repository,
              :invoice_repository,
              :invoice_item_repository,
              :item_repository,
              :transaction_repository,
              :filepath

  def initialize(filepath)
    @filepath = filepath
  end

  def startup
    # add memoization
    @customer_repository = CustomerRepository.new(self)
    @customer_repository.load_data("#{@filepath}/customers.csv")
    @merchant_repository = MerchantRepository.new(self)
    @merchant_repository.load_data("#{@filepath}/merchants.csv")
    @transaction_repository = TransactionRepository.new(self)
    @transaction_repository.load_data("#{@filepath}/transactions.csv")
    @item_repository = ItemRepository.new(self)
    @item_repository.load_data("#{@filepath}/items.csv")
    @invoice_repository = InvoiceRepository.new(self)
    @invoice_repository.load_data("#{@filepath}/invoices.csv")
    @invoice_item_repository = InvoiceItemRepository.new(self)
    @invoice_item_repository.load_data("#{@filepath}/invoice_items.csv")
  end

  def find_invoices_by_customer_id(id)
    invoice_repository.find_all_by_customer_id(id)
  end

  def find_invoice_by_invoice_id(id)
    invoice_repository.find_by_id(id)
  end

  def find_items_by_merchant_id(id)
    item_repository.find_all_by_merchant_id(id)
  end

  def find_invoices_by_merchant_id(id)
    invoice_repository.find_all_by_merchant_id(id)
  end

  def find_invoice_items_by_item_id(id)
    invoice_item_repository.find_all_by_item_id(id)
  end

  def find_merchant_by_id(id)
    merchant_repository.find_by_id(id)
  end

  def find_item_by_id(id)
    item_repository.find_by_id(id)
  end

  def find_transactions_by_invoice_id(id)
    transaction_repository.find_all_by_invoice_id(id)
  end

  def find_invoice_items_by_invoice_id(id)
    invoice_item_repository.find_all_by_invoice_id(id)
  end

  def find_customer_by_id(id)
    customer_repository.find_by_id(id)
  end

  def find_all_the_invoice_items_by_invoice_id(id)
    invoice_items = invoice_item_repository.find_all_by_invoice_id(id)
    find_item_ids_by_invoice_items(invoice_items)
  end

  def find_item_ids_by_invoice_items(invoice_items)
    item_ids = invoice_items.map do |invoice_item|
      invoice_item.item_id
    end
    find_items_by_ids(item_ids)
  end

  def find_items_by_ids(item_ids)
    item_ids.map do |item_id|
      find_item_by_id(item_id)
    end
  end

  def find_invoices_by_transactions(successful_transactions)
    successful_transactions.map do |transaction|
      find_invoice_by_invoice_id(transaction.invoice_id)
    end
  end

  def find_customers_by_invoice_ids(invoice_ids)
    find_invoices_by_invoice_ids(invoice_ids).map do |invoice|
      find_customer_by_id(invoice.customer_id)
    end
  end

  def find_invoices_by_invoice_ids(ids)
    ids.map { |invoice_id| find_invoice_by_invoice_id(invoice_id) }
  end

  def find_most_items(x)
    find_items_by_ids(invoice_item_repository.find_most_items_sold[0..x-1])
  end

end
