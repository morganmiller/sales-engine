require_relative './customer_repository'
require_relative './merchant_repository'
require_relative './invoice_repository'
require_relative './invoice_item_repository'
require_relative './item_repository'
require_relative './transaction_repository'

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
    # might need to pass in self for spec harness
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


end
