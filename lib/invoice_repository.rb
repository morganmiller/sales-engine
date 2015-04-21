require_relative 'load_file'
require_relative 'invoice'

class InvoiceRepository
attr_reader :invoices, :sales_engine

  include LoadFile

    def initialize(sales_engine)
      @invoices = []
      @sales_engine = sales_engine
    end

    def load_data(path)
      file = load_file(path)
      @invoices = file.map do |line|
        Invoice.new(line, self)
      end
      file.close
    end

    def inspect
      "#<#{self.class} #{@invoices.size} rows>"
    end
end
