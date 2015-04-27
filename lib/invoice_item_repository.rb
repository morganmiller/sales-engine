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

  def find_most_items_sold
    unique_items = {}
    all.each do |invoice_item|
      if unique_items.has_key?(invoice_item.item_id)
        unique_items[invoice_item.item_id] << invoice_item.quantity
      else
        unique_items[invoice_item.item_id] = [invoice_item.quantity]
      end
    end
    total_quantities = unique_items.values.map do |quantities|
      quantities.reduce(:+)
    end
    unsorted = unique_items.keys.zip(total_quantities)
    sorted = unsorted.sort_by { |item_id, quantity| -quantity }
    sorted.map { |a| a[0] }
  end
end

