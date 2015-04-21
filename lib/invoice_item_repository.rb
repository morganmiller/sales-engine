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
end
