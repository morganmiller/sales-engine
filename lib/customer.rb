class Customer
  attr_reader :id,
              :first_name,
              :last_name,
              :created_at,
              :updated_at,
              :repository

  def initialize(line, repository)
    @id         = line[:id].to_i
    @first_name = line[:first_name]
    @last_name  = line[:last_name]
    @created_at = line[:created_at]
    @updated_at = line[:updated_at]
    @repository = repository
  end

  def invoices
    repository.find_invoices(id)
  end

  def transactions
    repository.find_transactions(invoices)
  # require "pry"
  # binding.pry
  end

  def successful_customer_transactions
    transactions.delete_if {|t| !t.successful?}
  end

  # def favorite_merchant
  #   repository.find.........
  # end

  #need to finish by finding merchant id associated with successful transactions(already done) and
  #then finding the merchant with the most transactions
end
