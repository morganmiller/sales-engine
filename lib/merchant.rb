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

  def invoice_ids
    invoices.map do |inv|
      inv.id
    end
  end

  def transactions
    repository.find_transactions(invoices)
  end

  def successful_transactions
    transactions.flatten.select do |transaction|
      transaction if transaction.successful?
    end
  end

  def invoice_ids_that_have_transactions
    transactions.delete_if { |t| t == [] }.map { |t| t[0].invoice_id }
  end

  def iis_without_transactions
    invoice_ids.select{ |id| !invoice_ids_that_have_transactions.include?(id) }
  end

  def customers
    repository.retrieve_customers(successful_transactions)
  end

  def customer_occurrences
    customers.reduce(Hash.new(0)) do |result, occurrence|
      result[occurrence] += 1; result
    end
  end

  def favorite_customer
    customers.max_by { |occurrence| customer_occurrences[occurrence] }
  end

  def transactions_by_invoice_id
    transactions.reduce({}) do |result, transactions|
      id = transactions[0].invoice_id unless transactions[0].nil?
      result[id] = transactions
      result
    end
  end

  def iis_with_failed_transactions
    transactions_by_invoice_id.delete_if do |invoice_id, transactions|
      transactions.any? { |a| a.successful? } || invoice_id.nil?
    end
  end

  def all_missing_invoice_ids
    [iis_with_failed_transactions.keys, iis_without_transactions].flatten
  end

  def customers_with_pending_invoices
    repository.retrieve_customers_with_pending_invoices(all_missing_invoice_ids)
  end

  def revenue(date = nil)
    repository.total_revenue_for_a_merchant(id, date)
  end
end
