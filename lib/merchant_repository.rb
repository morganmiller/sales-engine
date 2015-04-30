require_relative 'load_csv'
require_relative 'merchant'

class MerchantRepository
  attr_reader :merchants, :sales_engine

  include LoadCSV

  def initialize(sales_engine)
    @merchants = []
    @sales_engine = sales_engine
  end

  def load_data(path)
    file = load_csv(path)
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

  def retrieve_customers(transactions)
    invoices = sales_engine.find_invoices_by_transactions(transactions)
    invoices.map do |invoice|
      sales_engine.find_customer_by_id(invoice.customer_id)
    end
  end

  def retrieve_customers_with_pending_invoices(invoice_ids)
    sales_engine.find_customers_by_invoice_ids(invoice_ids)
  end

  def successful_invoices(merchant_id)
    find_invoices(merchant_id).select do |i|
      i if sales_engine.invoice_ids_for_successful_transactions.include?(i.id)
    end
  end

  def successful_invoices_by_date(merchant_id, date)
    successful_invoices(merchant_id).select do |invoice|
      invoice if invoice.created_at == date
    end
  end

  def total_revenue_for_a_merchant(id, date = nil)
    if date.nil?
      sales_engine.total_merchant_revenue(successful_invoices(id))
    else
      sales_engine.total_merchant_revenue(successful_invoices_by_date(id, date))
    end
  end

  def total_revenue_for_all_merchants
    all.map do |merchant|
      [merchant, total_revenue_for_a_merchant(merchant.id)]
    end
  end

  def sorted_merchants_by_highest_revenue
    total_revenue_for_all_merchants.sort_by do |_merchant, total_revenue|
      -total_revenue
    end
  end

  def most_revenue(x)
    sorted_merchants_by_highest_revenue.map do |merchant_revenue|
      merchant_revenue[0]
    end[0..x-1]
  end

  def merchants_with_successful_invoices
    all.map do |merchant|
      [merchant, successful_invoices(merchant.id)]
    end
  end

  def associated_merchant_invoices
    merchants_with_successful_invoices.map do |merchant_and_invoices|
      merchant_and_invoices[1]
    end
  end

  def associated_merchant_invoice_items
    associated_merchant_invoices.map do |invoices|
      sales_engine.invoice_item_repository.find_invoice_items_from_ids(invoices)
    end
  end

  def quantity_of_individual_invoice_items
    associated_merchant_invoice_items.map do |invoice_items|
      invoice_items.map { |invoice_item| invoice_item.quantity }
    end
  end

  def total_quantities_in_order
    quantity_of_individual_invoice_items.map do |quantities|
      quantities.reduce(:+)
    end
  end

  def merchants_sorted_by_most_items_sold
    all.zip(total_quantities_in_order).sort_by do |_merchant, quantity|
      -quantity
    end
  end

  def most_items(x)
    merchants_sorted_by_most_items_sold.map do |merchant_and_quantity|
      merchant_and_quantity[0]
    end[0..x-1]
  end

  def invoices_for_each_date
    sales_engine.all_successful_invoices.group_by do |invoice|
      invoice.created_at
    end
  end

  def revenues_for_invoices
    invoices_for_each_date.values.map do |inv|
      sales_engine.invoice_item_repository.find_revenue_for_invoice_items(inv)
    end
  end

  def total_revenue_for_invoices
    revenues_for_invoices.map do |revenues|
      revenues.reduce(:+)
    end
  end

  def total_revenue_for_date_of_sale
    Hash[invoices_for_each_date.keys.zip(total_revenue_for_invoices)]
  end

  def revenue(date)
    total_revenue_for_date_of_sale.fetch(date)
  end
end
