require_relative 'load_csv'
require_relative 'invoice'

class InvoiceRepository
attr_reader :invoices, :sales_engine

  include LoadCSV

  def initialize(sales_engine)
    @invoices = []
    @sales_engine = sales_engine
  end

  def load_data(path)
    file = load_csv(path)
    @invoices = file.map do |line|
      Invoice.new(line, self)
    end
    file.close
  end

  def inspect
    "#<#{self.class} #{@invoices.size} rows>"
  end

  def all
    invoices
  end

  def random
    invoices.sample
  end

  def find_by_id(id)
    invoices.detect do |invoice|
      invoice.id == id
    end
  end

  def find_by_customer_id(customer_id)
    invoices.detect do |invoice|
      invoice.customer_id == customer_id
    end
  end

  def find_by_merchant_id(merchant_id)
    invoices.detect do |invoice|
      invoice.merchant_id == merchant_id
    end
  end

  def find_by_status(status)
    invoices.detect do |invoice|
      invoice.status == status
    end
  end

  def find_by_created_at(created_at)
    invoices.detect do |invoice|
      invoice.created_at == created_at
    end
  end

  def find_by_updated_at(updated_at)
    invoices.detect do |invoice|
      invoice.updated_at == updated_at
    end
  end

  def find_all_by_id(id)
    invoices.select do |invoice|
      invoice.id == id
    end
  end

  def find_all_by_customer_id(customer_id)
    invoices.select do |invoice|
      invoice.customer_id == customer_id
    end
  end

  def find_all_by_merchant_id(merchant_id)
    invoices.select do |invoice|
      invoice.merchant_id == merchant_id
    end
  end

  def find_all_by_status(status)
    invoices.select do |invoice|
      invoice.status == status
    end
  end

  def find_all_by_created_at(created_at)
    invoices.select do |invoice|
      invoice.created_at == created_at
    end
  end

  def find_all_by_updated_at(updated_at)
    invoices.select do |invoice|
      invoice.updated_at == updated_at
    end
  end

  def find_transactions(id)
    sales_engine.find_transactions_by_invoice_id(id)
  end

  def find_invoice_items(id)
    sales_engine.find_invoice_items_by_invoice_id(id)
  end

  def find_customer(customer_id)
    sales_engine.find_customer_by_id(customer_id)
  end

  def find_merchant(merchant_id)
    sales_engine.find_merchant_by_id(merchant_id)
  end

  def find_items(id)
    sales_engine.find_all_invoice_items_by_invoice_id(id)
  end

  def create(inputs)
  line = {
    id:          "#{invoices.last.id + 1}",
    customer_id: inputs[:customer].id,
    merchant_id: inputs[:merchant].id,
    status:      inputs[:status],
    created_at:  "#{Date.new}",
    updated_at:  "#{Date.new}",
          }

  new_inv = Invoice.new(line, self)
  invoices << new_inv

  sales_engine.create_new_items_with_invoice_id(inputs[:items], new_inv.id)
  new_inv
  end

  def new_charge(card_info, id)
    sales_engine.new_charge_with_invoice_id(card_info, id)
  end
end
