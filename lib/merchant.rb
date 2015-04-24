require 'pry'

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

  def invoice_id_collection
    invoices.map do |inv|
      inv.id
    end
  end

  def transactions
    repository.find_transactions(invoices)
  end

  def transactions_invoice_id_collection
    remainder = transactions.delete_if { |t| t == [] }
    remainder.map { |t| t[0].invoice_id }
  end

  def missing_invoice_ids
    invoice_id_collection.select{ |id| !transactions_invoice_id_collection.include?(id) }
  end

  ###Refactor, find something better than each: flat_map?
  def successful_transactions
    successful_transactions = []
    transactions.flatten.each do |transaction|
      successful_transactions << transaction if transaction.successful?
    end
    successful_transactions
  end

  def customers
    repository.retrieve_customers(successful_transactions)
  end

  def favorite_customer
    customers_and_frequency = customers.inject(Hash.new(0)) do |cust, freq|
      cust[freq] += 1; cust
    end
    customers.max_by { |freq| customers_and_frequency[freq] }
  end

  def customers_with_pending_invoices
    transactions_by_invoice_id = {}
    transactions.each do |trans|
      id = trans[0].invoice_id unless trans[0].nil?
      transactions_by_invoice_id[id] = trans
    end

    transactions_by_invoice_id.delete_if do |invoice_id, transactions|
      transactions.any? { |a| a.successful? } || invoice_id.nil?
    end

    all_missing_invoice_ids = [transactions_by_invoice_id.keys, missing_invoice_ids].flatten
    repository.retrieve_customers_with_pending_invoices(all_missing_invoice_ids)
  end
end


