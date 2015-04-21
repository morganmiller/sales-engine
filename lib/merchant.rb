class Merchant
  attr_reader :id,
              :name,
              :created_at,
              :updated_at

  def initialize(line, repository)
    @id           = line[:id].to_i
    @name         = line[:name]
    @created_at   = line[:created_at]
    @updated_at   = line[:updated_at]
    @repository   = repository
  end
end
