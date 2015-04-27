require_relative 'load_file'
require_relative 'customer'

class CustomerRepository
  attr_reader :customers, :sales_engine

  include LoadFile

  def initialize(sales_engine)
    @customers = []
    @sales_engine = sales_engine
  end

  def load_data(path)
    file = load_file(path)
    @customers = file.map do |line|
      Customer.new(line, self)
    end
    file.close
  end

  def inspect
    "#<#{self.class} #{@customers.size} rows>"
  end

  def all
    customers
  end

  def random
    customers.sample
  end

  def find_by_id(id)
    customers.detect do |customer|
      customer.id == id
    end
  end

  def find_by_first_name(first_name)
    customers.detect do |customer|
      customer.first_name == first_name
    end
  end

  def find_by_last_name(last_name)
    customers.detect do |customer|
      customer.last_name == last_name
    end
  end

  def find_by_created_at(created_at)
    customers.detect do |customer|
      customer.created_at == created_at
    end
  end

  def find_by_updated_at(updated_at)
    customers.detect do |customer|
      customer.updated_at == updated_at
    end
  end

  def find_all_by_id(id)
    customers.select do |customer|
      customer.id == id
    end
  end

  def find_all_by_first_name(first_name)
    customers.select do |customer|
      customer.first_name == first_name
    end
  end

  def find_all_by_last_name(last_name)
    customers.select do |customer|
      customer.last_name == last_name
    end
  end

  def find_all_by_created_at(created_at)
    customers.select do |customer|
      customer.created_at == created_at
    end
  end

  def find_all_by_updated_at(updated_at)
    customers.select do |customer|
      customer.updated_at == updated_at
    end
  end

  def find_invoices(id)
    sales_engine.find_invoices_by_customer_id(id)
  end

  def find_transactions(invoices)
    invoices.flat_map do |invoice|
      sales_engine.find_transactions_by_invoice_id(invoice.id)
    end
  end

  def find_merchant_ids_by_invoice_ids(invoice_ids)
    invoices = sales_engine.find_invoices_by_invoice_ids(invoice_ids)
      invoices.map do |invoice|
      invoice.merchant_id
    end
  end

  def find_favorite_merchant_id(successful_customer_transactions)
    favorite_merchant_id = find_merchant_ids_by_invoice_ids(find_all_invoice_ids(successful_customer_transactions)).max_by do |id|
      find_merchant_ids_by_invoice_ids(find_all_invoice_ids(successful_customer_transactions)).count(id)
    end
    sales_engine.find_merchant_by_id(favorite_merchant_id)
  end

  def find_all_invoice_ids(successful_customer_transactions)
    invoice_ids= successful_customer_transactions.map do |transaction|
      transaction.invoice_id
    end
  end
end
