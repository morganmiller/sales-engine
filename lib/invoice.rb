class Invoice
  attr_reader :id,
              :customer_id,
              :merchant_id,
              :status,
              :created_at,
              :updated_at,
              :repository

  def initialize(line, repository)
    @id           = line[:id].to_i
    @customer_id  = line[:customer_id].to_i
    @merchant_id  = line[:merchant_id].to_i
    @status       = line[:status]
    @created_at   = line[:created_at]
    @updated_at   = line[:updated_at]
    @repository   = repository
  end

  def transactions
    repository.find_transactions(id)
  end

  def invoice_items
    repository.find_invoice_items(id)
  end

  def customer
    repository.find_customer(customer_id)
  end

  def merchant
    repository.find_merchant(merchant_id)
  end

  def items
    repository.find_items(id)
  end
end

  #
  #   describe "#invoice_items" do
  #     it "has the correct number of them" do
  #       expect(invoice.invoice_items.size).to eq 3
  #     end
  #
  #     it "has one for a specific item" do
  #       invoice_item_names = invoice.invoice_items.map { |ii| ii.item.name }
  #       expect(invoice_item_names).to include 'Item Accusamus Officia'
  #     end
  #   end
  # end
