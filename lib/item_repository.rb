require_relative 'load_csv'
require_relative 'item'

class ItemRepository
  attr_reader :items, :sales_engine

  include LoadCSV

  def initialize(sales_engine)
    @items = []
    @sales_engine = sales_engine
  end

  def load_data(path)
    file = load_csv(path)
    @items = file.map do |line|
      Item.new(line, self)
    end
    file.close
  end

  def inspect
    "#<#{self.class} #{@items.size} rows>"
  end

  def all
    items
  end

  def random
    items.sample
  end

  def find_by_id(id)
    items.detect do |item|
      item.id == id
    end
  end

  def find_by_name(name)
    items.detect do |item|
      item.name == name
    end
  end

  def find_by_description(description)
    items.detect do |item|
      item.description == description
    end
  end

  def find_by_unit_price(unit_price)
    items.detect do |item|
      item.unit_price == unit_price
    end
  end

  def find_by_merchant_id(merchant_id)
    items.detect do |item|
      item.merchant_id == merchant_id
    end
  end

  def find_by_created_at(created_at)
    items.detect do |item|
      item.created_at == created_at
    end
  end

  def find_by_updated_at(updated_at)
    items.detect do |item|
      item.updated_at == updated_at
    end
  end

  def find_all_by_id(id)
    items.select do |item|
      item.id == id
    end
  end

  def find_all_by_name(name)
    items.select do |item|
      item.name == name
    end
  end

  def find_all_by_description(description)
    items.select do |item|
      item.description == description
    end
  end

  def find_all_by_unit_price(unit_price)
    items.select do |item|
      item.unit_price == unit_price
    end
  end

  def find_all_by_merchant_id(merchant_id)
    items.select do |item|
      item.merchant_id == merchant_id
    end
  end

  def find_all_by_created_at(created_at)
    items.select do |item|
      item.created_at == created_at
    end
  end

  def find_all_by_updated_at(updated_at)
    items.select do |item|
      item.updated_at == updated_at
    end
  end

  def find_invoice_items(id)
    sales_engine.find_invoice_items_by_item_id(id)
  end

  def find_merchant(merchant_id)
    sales_engine.find_merchant_by_id(merchant_id)
  end

  def most_items(x)
    sales_engine.find_most_items(x)
  end

  def most_revenue(x)
    sales_engine.find_most_revenue_for_items(x)
  end

  def yo_item_heres_your_invoice_items(id)
    sales_engine.invoice_item_repository.find_all_by_item_id(id)
  end

  def invoices_for_invoice_items(id)
    yo_item_heres_your_invoice_items(id).flat_map do |invoice_item|
      sales_engine.invoice_repository.find_all_by_id(invoice_item.invoice_id)
    end
  end

  def dates_shit_was_sold(id)
    invoices_for_invoice_items(id).map do |invoice|
      invoice.created_at
    end
  end

  def dates_and_invoice_items(id)
    dates_shit_was_sold(id).zip(yo_item_heres_your_invoice_items(id))
  end

  def quant_sold(id)
    hashy = {}
    dates_and_invoice_items(id).map do |date, invoice_item|
      if hashy.has_key?(date)
        hashy[date] << invoice_item.quantity
      else
        hashy[date] = [invoice_item.quantity]
      end
    end
    hashy
  end

  def summed_quantities_for_best_day(id)
    sales_engine.invoice_item_repository.total_quantities(quant_sold(id).values)
  end

  def dates_and_best_day_quant(id)
    quant_sold(id).keys.zip(summed_quantities_for_best_day(id))
  end

  def find_best_day(id)
    dates_and_best_day_quant(id).sort_by do |_date, quantity|
      -quantity
    end.first[0]
  end
end
