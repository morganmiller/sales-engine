class Transaction
  attr_reader :id,
              :invoice_id,
              :credit_card_number,
              :credit_card_expiration_date,
              :created_at,
              :updated_at,
              :result,
              :repository

  def initialize(line, repository)
    @id                          = line[:id].to_i
    @invoice_id                  = line[:invoice_id].to_i
    @credit_card_number          = line[:credit_card_number]
    @credit_card_expiration_date = line[:credit_card_expiration_date]
    @created_at                  = line[:created_at]
    @updated_at                  = line[:updated_at]
    @result                      = line[:result]
    @repository                  = repository
  end

  def invoice
    repository.find_invoice(invoice_id)
  end

  def successful?
    result == "success"
  end

end
