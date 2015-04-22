require 'bigdecimal'

class Item
  attr_reader :id,
              :name,
              :description,
              :unit_price,
              :merchant_id,
              :created_at,
              :updated_at

  def initialize(line, repository)
    @id           = line[:id].to_i
    @name         = line[:name]
    @description  = line[:description]
    @unit_price   = BigDecimal.new(line[:unit_price])/100
    @merchant_id  = line[:merchant_id].to_i
    @created_at   = line[:created_at]
    @updated_at   = line[:updated_at]
    @repository   = repository
  end
end
