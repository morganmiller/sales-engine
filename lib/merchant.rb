class Merchant
  attr_reader :id,
              :name,
              :created_at,
              :updated_at,
              :repository

  def initialize(line, repository)
    @id           = line[:id].to_i
    @name         = line[:name]
    @created_at   = line[:created_at]
    @updated_at   = line[:updated_at]
    @repository   = repository
  end

  def items
    repository.find_items(id)
  end

  def invoices
    repository.find_invoices(id)
  end

  def favorite_customer
    # require 'pry'
    # binding.pry
    transactions = repository.find_transactions(invoices).flatten
    successful_transactions = []
    transactions.each do |transaction|
      successful_transactions << transaction if transaction.successful?
    end
    customers = repository.retrieve_customers(successful_transactions)
    customers_and_frequency = customers.inject(Hash.new(0)) { |cust, freq| cust[freq] += 1; cust }
    customers.max_by { |freq| customers_and_frequency[freq] }
  end
end


