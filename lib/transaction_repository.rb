require_relative 'load_file'
require_relative 'transaction'

class TransactionRepository
attr_reader :transactions, :sales_engine

  include LoadFile

    def initialize(sales_engine)
      @transactions = []
      @sales_engine = sales_engine
    end

    def load_data(path)
      file = load_file(path)
      @transactions = file.map do |line|
        Transaction.new(line, self)
      end
      file.close
    end

    def inspect
      "#<#{self.class} #{@transactions.size} rows>"
    end
end
