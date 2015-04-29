require 'csv'

module LoadCSV
  def load_csv(path)
    CSV.open(path, headers: true, header_converters: :symbol)
  end
end
