require_relative 'load_file'
require_relative 'merchant'

class MerchantRepository
  attr_reader :merchants, :sales_engine

  include LoadFile

  def initialize(sales_engine)
    @merchants = []
    @sales_engine = sales_engine
  end

  def load_data(path)
    file = load_file(path)
    @merchants = file.map do |line|
      Merchant.new(line, self)
    end
    file.close
  end

  def inspect
    "#<#{self.class} #{@merchants.size} rows>"
  end

  def all
    merchants
  end

  def random
    merchants.sample
  end

  def find_by_id(id)
    merchants.detect do |merchant|
      merchant.id == id
    end
  end

  def find_by_name(name)
    merchants.detect do |merchant|
      merchant.name == name
    end
  end

  def find_by_created_at(created_at)
    merchants.detect do |merchant|
      merchant.created_at == created_at
    end
  end

  def find_by_updated_at(updated_at)
    merchants.detect do |merchant|
      merchant.updated_at == updated_at
    end
  end

  def find_all_by_id(id)
    merchants.select do |merchant|
      merchant.id == id
    end
  end

  def find_all_by_name(name)
    merchants.select do |merchant|
      merchant.name == name
    end
  end

  def find_all_by_created_at(created_at)
    merchants.select do |merchant|
      merchant.created_at == created_at
    end
  end

  def find_all_by_updated_at(updated_at)
    merchants.select do |merchant|
      merchant.updated_at == updated_at
    end
  end

  def find_items(id)
    sales_engine.find_items_by_merchant_id(id)
  end

  def find_invoices(id)
    sales_engine.find_invoices_by_merchant_id(id)
  end

  def find_transactions(invoices)
    invoices.map do |invoice|
      sales_engine.find_transactions_by_invoice_id(invoice.id)
    end
  end

  def retrieve_customers(successful_transactions)
    invoices = sales_engine.find_invoices_by_transactions(successful_transactions)
    invoices.map do |invoice|
      sales_engine.find_customer_by_id(invoice.customer_id)
    end
  end

  def retrieve_customers_with_pending_invoices(invoice_ids)
    sales_engine.find_customers_by_invoice_ids(invoice_ids)
  end

  def successful_invoices(merchant_id)
    find_invoices(merchant_id).select do |invoice|
      invoice if sales_engine.invoice_ids_for_successful_transactions.include?(invoice.id)
    end
  end

  def successful_invoices_by_date(merchant_id, date)
    successful_invoices(merchant_id).select do |invoice|
      invoice if invoice.created_at == date
    end
  end

  def total_revenue_for_a_merchant(merchant_id, date = nil)
    if date.nil?
      sales_engine.total_merchant_revenue(successful_invoices(merchant_id))
    else
      sales_engine.total_merchant_revenue(successful_invoices_by_date(merchant_id, date))
    end
  end

  def total_revenue_for_all_merchants
    all.map do |merchant|
      [merchant, total_revenue_for_a_merchant(merchant.id)]
    end
  end

  def sorted_merchants_by_highest_revenue
    total_revenue_for_all_merchants.sort_by { |merchant, total_revenue| -total_revenue }
  end

  def most_revenue(x)
    sorted_merchants_by_highest_revenue.map { |merchant_revenue| merchant_revenue[0] }[0..x-1]
  end

  def most_items(x)
    merchants_with_successful_invoices = all.map do |merchant|
      [merchant, successful_invoices(merchant.id)]
    end
    invoices_ordered_by_merchant = merchants_with_successful_invoices.map do |merchant_and_invoices|
      merchant_and_invoices[1]
    end
    invoice_items_ordered_by_merchant = invoices_ordered_by_merchant.map do |invoices|
      sales_engine.invoice_item_repository.find_invoice_items_from_invoice_ids(invoices)
    end
    quantity_of_individual_invoice_items = invoice_items_ordered_by_merchant.map do |invoice_items|
      invoice_items.map { |invoice_item| invoice_item.quantity }
    end
    ordered_total_quantities = quantity_of_individual_invoice_items.map do |quantities|
      quantities.reduce(:+)
    end
    ordered_merchants = merchants_with_successful_invoices.map do |merchants_and_invoices|
      merchants_and_invoices[0]
    end
    sorted_merchants_by_quantity = ordered_merchants.zip(ordered_total_quantities).sort_by do |merchant, quantity|
      -quantity
    end
    sorted_merchants_by_quantity.map do |merchant_and_quantity|
      merchant_and_quantity[0]
    end[0..x-1]
  end

end
