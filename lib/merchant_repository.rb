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
end
