require_relative 'load_csv'
require_relative 'transaction'

class TransactionRepository
  attr_reader :transactions, :sales_engine

  include LoadCSV

  def initialize(sales_engine)
    @transactions = []
    @sales_engine = sales_engine
  end

  def load_data(path)
    file = load_csv(path)
    @transactions = file.map do |line|
      Transaction.new(line, self)
    end
    file.close
  end

  def inspect
    "#<#{self.class} #{@transactions.size} rows>"
  end

  def all
    transactions
  end

  def random
    transactions.sample
  end

  def find_by_id(id)
    transactions.detect do |transaction|
      transaction.id == id
    end
  end

  def find_by_invoice_id(invoice_id)
    transactions.detect do |transaction|
      transaction.invoice_id == invoice_id
    end
  end

  def find_by_credit_card_number(credit_card_number)
    transactions.detect do |transaction|
      transaction.credit_card_number == credit_card_number
    end
  end

  def find_by_credit_card_expiration_date(credit_card_expiration_date)
    transactions.detect do |transaction|
      transaction.credit_card_expiration_date == credit_card_expiration_date
    end
  end

  def find_by_created_at(created_at)
    transactions.detect do |transaction|
      transaction.created_at == created_at
    end
  end

  def find_by_updated_at(updated_at)
    transactions.detect do |transaction|
      transaction.updated_at == updated_at
    end
  end

  def find_by_result(result)
    transactions.detect do |transaction|
      transaction.result == result
    end
  end

  def find_all_by_id(id)
    transactions.select do |transaction|
      transaction.id == id
    end
  end

  def find_all_by_invoice_id(invoice_id)
    transactions.select do |transaction|
      transaction.invoice_id == invoice_id
    end
  end

  def find_all_by_credit_card_number(credit_card_number)
    transactions.select do |transaction|
      transaction.credit_card_number == credit_card_number
    end
  end

  def find_all_by_credit_card_expiration_date(credit_card_expiration_date)
    transactions.select do |transaction|
      transaction.credit_card_expiration_date == credit_card_expiration_date
    end
  end

  def find_all_by_created_at(created_at)
    transactions.select do |transaction|
      transaction.created_at == created_at
    end
  end

  def find_all_by_updated_at(updated_at)
    transactions.select do |transaction|
      transaction.updated_at == updated_at
    end
  end

  def find_all_by_result(result)
    transactions.select do |transaction|
      transaction.result == result
    end
  end

  def find_invoice(invoice_id)
    sales_engine.find_invoice_by_invoice_id(invoice_id)
  end

  def successful_transactions
    @transaction_success ||= all.select do |transaction|
      transaction if transaction.successful?
    end
  end

  def create_new_charge(card_info, id)
    card_info = {
      id:                     "#{transactions.last.id + 1}",
      invoice_id:             id,
      credit_card_number:     card_info[:credit_card_number],
      credit_card_expiration: card_info[:credit_card_expiration],
      result:                 card_info[:result],
      created_at:             "#{Date.new}",
      updated_at:             "#{Date.new}"
      }

    new_transaction = Transaction.new(card_info, self)
    transactions << new_transaction
  end
end
