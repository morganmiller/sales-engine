require_relative '../test/test_helper'
require_relative '../lib/customer_repository'

class CustomerRepositoryTest < Minitest::Test

  def test_it_starts_with_an_empty_array_of_customers
    customer_repository = CustomerRepository.new(nil)
    assert_equal [], customer_repository.customers
  end

  def test_it_can_load_data_to_customer
    customer_repository = CustomerRepository.new(nil)
    customer_repository.load_data("./test/fixtures/customers.csv")

    assert_equal 5 , customer_repository.customers.length
    assert_equal "Joey", customer_repository.customers.first.first_name
    assert_equal 1, customer_repository.customers.first.id
    assert_equal "Toy", customer_repository.customers[2].last_name
  end

  def test_it_can_return_all_customers
    customer_repository = CustomerRepository.new(nil)
    customer_repository.load_data("./test/fixtures/customers.csv")
    result = customer_repository.all.map {|customer| customer.id}

    assert_equal [1, 2, 3, 4, 5], result
  end

  def test_it_can_find_a_random_customer
    customer_repository = CustomerRepository.new(nil)
    customer_repository.load_data("./test/fixtures/customers.csv")
    random_sample = customer_repository.random

    assert random_sample.is_a?(Customer)
  end

  def test_it_can_find_a_customer_by_id
    customer_repository = CustomerRepository.new(nil)
    customer_repository.load_data("./test/fixtures/customers.csv")

    assert_equal "Joey", customer_repository.find_by_id(1).first_name
    assert_equal "Ondricka", customer_repository.find_by_id(1).last_name
    assert_equal "Cecelia", customer_repository.find_by_id(2).first_name
  end

  def test_it_can_find_a_customers_first_name
    customer_repository = CustomerRepository.new(nil)
    customer_repository.load_data("./test/fixtures/customers.csv")

    assert_equal "Joey", customer_repository.find_by_first_name("Joey").first_name
    assert_equal 1, customer_repository.find_by_first_name("Joey").id
  end

  def test_it_can_find_a_customers_last_name
    customer_repository = CustomerRepository.new(nil)
    customer_repository.load_data("./test/fixtures/customers.csv")

    assert_equal "Mariah", customer_repository.find_by_last_name("Toy").first_name
    assert_equal 3, customer_repository.find_by_last_name("Toy").id
  end

  def test_it_can_find_a_customer_by_created_at_date
    customer_repository = CustomerRepository.new(nil)
    customer_repository.load_data("./test/fixtures/customers.csv")

    assert_equal "Joey", customer_repository.find_by_created_at("2012-03-27 14:54:09 UTC").first_name
    assert_equal 1, customer_repository.find_by_created_at("2012-03-27 14:54:09 UTC").id
  end

  def test_it_can_find_a_customer_by_updated_at_date
    customer_repository = CustomerRepository.new(nil)
    customer_repository.load_data("./test/fixtures/customers.csv")

    assert_equal "Joey", customer_repository.find_by_updated_at("2012-03-27 14:54:09 UTC").first_name
    assert_equal 1, customer_repository.find_by_updated_at("2012-03-27 14:54:09 UTC").id
  end

  def test_it_can_find_all_customers_by_id
    customer_repository = CustomerRepository.new(nil)
    customer_repository.load_data("./test/fixtures/customers.csv")
    result   = customer_repository.find_all_by_id(1)
    result_2 = customer_repository.find_all_by_id(2)

    assert_equal "Joey", result[0].first_name
    assert_equal "Cecelia", result_2[0].first_name
  end

  def test_it_can_find_all_customers_by_first_name
    customer_repository = CustomerRepository.new(nil)
    customer_repository.load_data("./test/fixtures/customers.csv")
    result   = customer_repository.find_all_by_first_name("Joey")
    result_2 = customer_repository.find_all_by_first_name("Cecelia")

    assert_equal 1, result[0].id
    assert_equal 2, result_2[0].id
  end

  def test_it_can_find_all_customers_by_last_name
    customer_repository = CustomerRepository.new(nil)
    customer_repository.load_data("./test/fixtures/customers.csv")

    result   = customer_repository.find_all_by_last_name("Toy")
    result_2 = customer_repository.find_all_by_last_name("Braun")

    assert_equal 3, result[0].id
    assert_equal 4, result_2[0].id
  end

  def test_it_can_find_all_customers_by_created_at_date
    customer_repository = CustomerRepository.new(nil)
    customer_repository.load_data("./test/fixtures/customers.csv")

    assert_equal 1, customer_repository.find_all_by_created_at("2012-03-27 14:54:09 UTC").count
    assert_equal 4, customer_repository.find_all_by_created_at("2012-03-27 14:54:10 UTC").count
  end

  def test_it_can_find_all_customers_by_updated_at_date
    customer_repository = CustomerRepository.new(nil)
    customer_repository.load_data("./test/fixtures/customers.csv")

    assert_equal 1, customer_repository.find_all_by_updated_at("2012-03-27 14:54:09 UTC").count
    assert_equal 4, customer_repository.find_all_by_updated_at("2012-03-27 14:54:10 UTC").count
  end

end
