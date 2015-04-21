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

  # def inspect
  #   "#<#{self.class} #{@customers.size} rows>"
  # end

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
  # :id,
  #            :first_name,
  #            :last_name,
  #            :created_at,
  #            :updated_at,

end