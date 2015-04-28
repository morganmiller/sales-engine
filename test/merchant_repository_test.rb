require_relative '../test/test_helper'
require_relative '../lib/merchant_repository'

class MerchantRepositoryTest < Minitest::Test

  def test_it_starts_with_an_empty_array_of_merchants
    merchant_repository = MerchantRepository.new(nil)
    
    assert_equal [], merchant_repository.merchants
  end

  def test_it_can_load_data_to_merchant
    merchant_repository = MerchantRepository.new(nil)
    merchant_repository.load_data("./test/fixtures/merchants.csv")

    assert_equal 5 , merchant_repository.merchants.length
    assert_equal "Schroeder-Jerde", merchant_repository.merchants.first.name
    assert_equal 1, merchant_repository.merchants.first.id
  end

  def test_it_can_return_all_merchants
    merchant_repository = MerchantRepository.new(nil)
    merchant_repository.load_data("./test/fixtures/merchants.csv")
    result = merchant_repository.all.map {|merchant| merchant.id}

    assert_equal [1, 2, 3, 4, 5], result
  end

  def test_it_can_find_a_random_merchant
    merchant_repository = MerchantRepository.new(nil)
    merchant_repository.load_data("./test/fixtures/merchants.csv")
    random_sample = merchant_repository.random

    assert random_sample.is_a?(Merchant)
  end

  def test_it_can_find_a_merchant_by_id
    merchant_repository = MerchantRepository.new(nil)
    merchant_repository.load_data("./test/fixtures/merchants.csv")

    assert_equal "Schroeder-Jerde", merchant_repository.find_by_id(1).name
    assert_equal "2012-03-27 14:53:59 UTC", merchant_repository.find_by_id(1).created_at
    assert_equal "Klein, Rempel and Jones", merchant_repository.find_by_id(2).name
  end

  def test_it_can_find_a_merchant_by_name
    merchant_repository = MerchantRepository.new(nil)
    merchant_repository.load_data("./test/fixtures/merchants.csv")

    assert_equal 3, merchant_repository.find_by_name("Willms and Sons").id
    assert_equal "2012-03-27 14:53:59 UTC", merchant_repository.find_by_name("Williamson Group").created_at
    assert_equal 1, merchant_repository.find_by_name("Schroeder-Jerde").id
  end

  def test_it_can_find_a_merchant_by_created_at_date
    merchant_repository = MerchantRepository.new(nil)
    merchant_repository.load_data("./test/fixtures/merchants.csv")

    assert_equal "Schroeder-Jerde", merchant_repository.find_by_created_at("2012-03-27 14:53:59 UTC").name
    assert_equal 1, merchant_repository.find_by_created_at("2012-03-27 14:53:59 UTC").id
  end

  def test_it_can_find_a_merchant_by_updated_at_date
    merchant_repository = MerchantRepository.new(nil)
    merchant_repository.load_data("./test/fixtures/merchants.csv")

    assert_equal "Schroeder-Jerde", merchant_repository.find_by_updated_at("2012-03-27 14:53:59 UTC").name
    assert_equal 1, merchant_repository.find_by_updated_at("2012-03-27 14:53:59 UTC").id
  end

  def test_it_can_find_all_merchants_by_id
    merchant_repository = MerchantRepository.new(nil)
    merchant_repository.load_data("./test/fixtures/merchants.csv")
    result   = merchant_repository.find_all_by_id(1)
    result_2 = merchant_repository.find_all_by_id(2)

    assert_equal "Schroeder-Jerde", result[0].name
    assert_equal "Klein, Rempel and Jones", result_2[0].name
  end

  def test_it_can_find_all_merchants_by_name
    merchant_repository = MerchantRepository.new(nil)
    merchant_repository.load_data("./test/fixtures/merchants.csv")
    result   = merchant_repository.find_all_by_name("Schroeder-Jerde")
    result_2 = merchant_repository.find_all_by_name("Klein, Rempel and Jones")

    assert_equal 1, result[0].id
    assert_equal 2, result_2[0].id
  end

  def test_it_can_find_all_merchants_by_created_at_date
    merchant_repository = MerchantRepository.new(nil)
    merchant_repository.load_data("./test/fixtures/merchants.csv")

    assert_equal 5, merchant_repository.find_all_by_created_at("2012-03-27 14:53:59 UTC").count
  end

  def test_it_can_find_all_merchants_by_updated_at_date
    merchant_repository = MerchantRepository.new(nil)
    merchant_repository.load_data("./test/fixtures/merchants.csv")

    assert_equal 5, merchant_repository.find_all_by_updated_at("2012-03-27 14:53:59 UTC").count
  end


end
