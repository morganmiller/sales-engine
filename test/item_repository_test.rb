require_relative '../test/test_helper'
require_relative '../lib/item_repository'

class ItemRepositoryTest < Minitest::Test

  def test_it_starts_with_an_empty_array_of_items
    item_repository = ItemRepository.new(nil)
    assert_equal [], item_repository.items
  end

  def test_it_can_load_data_to_item_repository
    item_repository = ItemRepository.new(nil)
    item_repository.load_data("./test/fixtures/items.csv")

    assert_equal 5 , item_repository.items.length
    assert_equal 1, item_repository.items.first.id
    assert_equal "Item Ea Voluptatum", item_repository.items[2].name
  end

  def test_it_can_return_all_items
    item_repository = ItemRepository.new(nil)
    item_repository.load_data("./test/fixtures/items.csv")
    result = item_repository.all.map {|item| item.id}

    assert_equal [1, 2, 3, 4, 5], result
  end

  def test_it_can_find_a_random_item
    item_repository = ItemRepository.new(nil)
    item_repository.load_data("./test/fixtures/items.csv")
    random_sample = item_repository.random

    assert random_sample.is_a?(Item)
  end

  def test_it_can_find_an_item_by_id
    item_repository = ItemRepository.new(nil)
    item_repository.load_data("./test/fixtures/items.csv")

    assert_equal "Item Qui Esse", item_repository.find_by_id(1).name
    assert_equal "Nihil autem sit odio inventore deleniti. Est laudantium ratione distinctio laborum. Minus voluptatem nesciunt assumenda dicta voluptatum porro.", item_repository.find_by_id(1).description
    assert_equal "Item Autem Minima", item_repository.find_by_id(2).name
  end

  def test_it_can_find_an_item_by_name
    item_repository = ItemRepository.new(nil)
    item_repository.load_data("./test/fixtures/items.csv")

    assert_equal 1, item_repository.find_by_name("Item Qui Esse").id
    assert_equal "Nihil autem sit odio inventore deleniti. Est laudantium ratione distinctio laborum. Minus voluptatem nesciunt assumenda dicta voluptatum porro.", item_repository.find_by_name("Item Qui Esse").description
    assert_equal 2, item_repository.find_by_name("Item Autem Minima").id
  end

  def test_it_can_find_an_item_by_description
    item_repository = ItemRepository.new(nil)
    item_repository.load_data("./test/fixtures/items.csv")

    assert_equal 1, item_repository.find_by_description("Nihil autem sit odio inventore deleniti. Est laudantium ratione distinctio laborum. Minus voluptatem nesciunt assumenda dicta voluptatum porro.").id
    assert_equal 2, item_repository.find_by_description("Cumque consequuntur ad. Fuga tenetur illo molestias enim aut iste. Provident quo hic aut. Aut quidem voluptates dolores. Dolorem quae ab alias tempora.").id
  end

  def test_it_can_find_an_item_by_unit_price
    item_repository = ItemRepository.new(nil)
    item_repository.load_data("./test/fixtures/items.csv")

    assert_equal 2, item_repository.find_by_unit_price(BigDecimal.new(67076)/100).id
  end

  def test_it_can_find_an_item_by_merchant_id
    item_repository = ItemRepository.new(nil)
    item_repository.load_data("./test/fixtures/items.csv")

    assert_equal 1, item_repository.find_by_merchant_id(1).id
  end

  def test_it_can_find_an_item_by_created_at_date
    item_repository = ItemRepository.new(nil)
    item_repository.load_data("./test/fixtures/items.csv")

    assert_equal 1, item_repository.find_by_created_at("2012-03-27 14:53:59 UTC").id
    assert_equal 1, item_repository.find_by_created_at("2012-03-27 14:53:59 UTC").merchant_id
  end

  def test_it_can_find_an_item_by_updated_at_date
    item_repository = ItemRepository.new(nil)
    item_repository.load_data("./test/fixtures/items.csv")

    assert_equal 1, item_repository.find_by_updated_at("2012-03-27 14:53:59 UTC").id
    assert_equal 1, item_repository.find_by_updated_at("2012-03-27 14:53:59 UTC").merchant_id
  end

  def test_it_can_find_all_items_by_id
    item_repository = ItemRepository.new(nil)
    item_repository.load_data("./test/fixtures/items.csv")

    assert_equal 1, item_repository.find_all_by_id(1).count
    assert_equal "Item Qui Esse", item_repository.find_all_by_id(1)[0].name
  end

  def test_it_can_find_all_items_by_name
    item_repository = ItemRepository.new(nil)
    item_repository.load_data("./test/fixtures/items.csv")

    assert_equal 1, item_repository.find_all_by_name("Item Qui Esse").count
    assert_equal "Nihil autem sit odio inventore deleniti. Est laudantium ratione distinctio laborum. Minus voluptatem nesciunt assumenda dicta voluptatum porro.", item_repository.find_all_by_name("Item Qui Esse")[0].description
    assert_equal 2, item_repository.find_all_by_name("Item Autem Minima")[0].id
  end

  def test_it_can_find_all_items_by_description
    item_repository = ItemRepository.new(nil)
    item_repository.load_data("./test/fixtures/items.csv")

    assert_equal 1, item_repository.find_all_by_description("Nihil autem sit odio inventore deleniti. Est laudantium ratione distinctio laborum. Minus voluptatem nesciunt assumenda dicta voluptatum porro.").count
    assert_equal 2, item_repository.find_all_by_description("Cumque consequuntur ad. Fuga tenetur illo molestias enim aut iste. Provident quo hic aut. Aut quidem voluptates dolores. Dolorem quae ab alias tempora.")[0].id
  end

  def test_it_can_find_all_items_by_unit_price
    item_repository = ItemRepository.new(nil)
    item_repository.load_data("./test/fixtures/items.csv")

    assert_equal 1, item_repository.find_all_by_unit_price(BigDecimal.new(67076)/100).count
  end

  def test_it_can_find_all_items_by_merchant_id
    item_repository = ItemRepository.new(nil)
    item_repository.load_data("./test/fixtures/items.csv")

    assert_equal 5, item_repository.find_all_by_merchant_id(1).count
  end

  def test_it_can_find_all_items_by_created_at_date
    item_repository = ItemRepository.new(nil)
    item_repository.load_data("./test/fixtures/items.csv")

    assert_equal 5, item_repository.find_all_by_created_at("2012-03-27 14:53:59 UTC").count
    assert_equal 1, item_repository.find_all_by_created_at("2012-03-27 14:53:59 UTC")[0].merchant_id
  end

  def test_it_can_find_all_items_by_updated_at_date
    item_repository = ItemRepository.new(nil)
    item_repository.load_data("./test/fixtures/items.csv")

    assert_equal 5, item_repository.find_all_by_updated_at("2012-03-27 14:53:59 UTC").count
    assert_equal 1, item_repository.find_all_by_updated_at("2012-03-27 14:53:59 UTC")[0].merchant_id
  end




end
