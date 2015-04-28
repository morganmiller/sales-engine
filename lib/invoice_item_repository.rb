require_relative 'load_file'
require_relative 'invoice_item'

class InvoiceItemRepository

attr_reader :invoice_items, :sales_engine

  include LoadFile

  def initialize(sales_engine)
    @invoice_items = []
    @sales_engine = sales_engine
  end

  def load_data(path)
    file = load_file(path)
    @invoice_items = file.map do |line|
      InvoiceItem.new(line, self)
    end
    file.close
  end

  def inspect
    "#<#{self.class} #{@invoice_items.size} rows>"
  end

  def all
    invoice_items
  end

  def random
    invoice_items.sample
  end

  def find_by_id(id)
    invoice_items.detect do |invoice_item|
      invoice_item.id == id
    end
  end

  def find_by_item_id(item_id)
    invoice_items.detect do |invoice_item|
      invoice_item.item_id == item_id
    end
  end

  def find_by_invoice_id(invoice_id)
    invoice_items.detect do |invoice_item|
      invoice_item.invoice_id == invoice_id
    end
  end

  def find_by_quantity(quantity)
    invoice_items.detect do |invoice_item|
      invoice_item.quantity == quantity
    end
  end

  def find_by_unit_price(unit_price)
    invoice_items.detect do |invoice_item|
      invoice_item.unit_price == unit_price
    end
  end

  def find_by_created_at(created_at)
    invoice_items.detect do |invoice_item|
      invoice_item.created_at == created_at
    end
  end

  def find_by_updated_at(updated_at)
    invoice_items.detect do |invoice_item|
      invoice_item.updated_at == updated_at
    end
  end

  def find_all_by_id(id)
    invoice_items.select do |invoice_item|
      invoice_item.id == id
    end
  end

  def find_all_by_item_id(item_id)
    invoice_items.select do |invoice_item|
      invoice_item.item_id == item_id
    end
  end

  def find_all_by_invoice_id(invoice_id)
    invoice_items.select do |invoice_item|
      invoice_item.invoice_id == invoice_id
    end
  end

  def find_all_by_quantity(quantity)
    invoice_items.select do |invoice_item|
      invoice_item.quantity == quantity
    end
  end

  def find_all_by_unit_price(unit_price)
    invoice_items.select do |invoice_item|
      invoice_item.unit_price == unit_price
    end
  end

  def find_all_by_created_at(created_at)
    invoice_items.select do |invoice_item|
      invoice_item.created_at == created_at
    end
  end

  def find_all_by_updated_at(updated_at)
    invoice_items.select do |invoice_item|
      invoice_item.updated_at == updated_at
    end
  end

  def find_invoice(invoice_id)
    sales_engine.find_invoice_by_invoice_id(invoice_id)
  end

  def find_item(item_id)
    sales_engine.find_item_by_id(item_id)
  end

  def invoice_items_with_successful_transactions
    all.map do |invoice_item|
      invoice_item if sales_engine.invoice_ids_for_successful_transactions.include?(invoice_item.invoice_id)
    end.delete_if {|invoice_item| invoice_item.nil?}
  end

  def invoice_items_with_quantities
    unique_items = {}
    invoice_items_with_successful_transactions.group_by do |invoice_item|
      invoice_item.item_id
      if unique_items.has_key?(invoice_item.item_id)
        unique_items[invoice_item.item_id] << invoice_item.quantity
      else
        unique_items[invoice_item.item_id] = [invoice_item.quantity]
      end
    end
    unique_items
  end

  def total_quantities(quantities_to_sum)
    quantities_to_sum.map do |quantity|
      quantity.reduce(:+)
    end
  end

  def items_sorted_by_total_quantities
    invoice_items_with_quantities.keys.zip(total_quantities(invoice_items_with_quantities.values)).sort_by do |item_id, quantity|
      -quantity
    end
  end

  def find_most_items_sold
    items_sorted_by_total_quantities.map { |a| a[0] }
  end

  def retrieve_items_by_ids
    sales_engine.find_items_by_ids(invoice_items_with_quantities.keys)
  end

  def all_unit_prices
    retrieve_items_by_ids.map do |item|
      item.unit_price
    end
  end

  def total_revenues
    tots = total_quantities(invoice_items_with_quantities.values).zip(all_unit_prices)
    tots.flat_map do |a|
      a[0] * a[1]
    end
  end

  def top_grossing_items
    sorted = invoice_items_with_quantities.keys.zip(total_revenues).sort_by do |item_id, revenue|
      -revenue
    end
    sorted.map { |a| a[0] }
  end

  def find_invoice_ids_from_invoices(invoices)
    invoices.map do |invoice|
      invoice.id
    end
  end

  def find_invoice_items_from_invoice_ids(invoices)
    find_invoice_ids_from_invoices(invoices).flat_map do |invoice_id|
      find_all_by_invoice_id(invoice_id)
    end
  end

  def find_revenue_for_invoice_items(invoices)
    find_invoice_items_from_invoice_ids(invoices).map do |inv_item|
      inv_item.revenue
    end
  end

  def find_total_revenue_for_a_merchant(invoices)
    find_revenue_for_invoice_items(invoices).reduce(:+)
  end

  def create_new_items(items, id)
    items.each do |item|
      grouped_items = items.group_by do |item|
        item
      end
      quantity = grouped_items.map do |item|
        item.count
      end.uniq.flatten.join
      line = {
        id:         "#{invoice_items.last.id + 1}",
        item_id:    item.id,
        invoice_id: id,
        quantity:   quantity,
        unit_price: item.unit_price,
        created_at: "#{Date.new}",
        updated_at: "#{Date.new}"
              }
     new_invoice_item = InvoiceItem.new(line, self)
     invoice_items << new_invoice_item
    end
  end

end
