require "test_helper"

class DistrictDataControllerTest < ActionDispatch::IntegrationTest
  setup do
    @district_datum = district_data(:one)
  end

  test "should get index" do
    get district_data_url
    assert_response :success
  end

  test "should get new" do
    get new_district_datum_url
    assert_response :success
  end

  test "should create district_datum" do
    assert_difference('DistrictDatum.count') do
      post district_data_url, params: { district_datum: { direct_competitors: @district_datum.direct_competitors, float,: @district_datum.float,, indirect_competitors: @district_datum.indirect_competitors, name: @district_datum.name, population: @district_datum.population, public_trans_lvl: @district_datum.public_trans_lvl, purchasing_power: @district_datum.purchasing_power, rent_index: @district_datum.rent_index, restaurant_price_index: @district_datum.restaurant_price_index, restaurant_type: @district_datum.restaurant_type, restaurant_type_num: @district_datum.restaurant_type_num, restaurants_avg_rating: @district_datum.restaurants_avg_rating, restaurants_price_avg_lvl: @district_datum.restaurants_price_avg_lvl, restaurants_sum_rating: @district_datum.restaurants_sum_rating } }
    end

    assert_redirected_to district_datum_url(DistrictDatum.last)
  end

  test "should show district_datum" do
    get district_datum_url(@district_datum)
    assert_response :success
  end

  test "should get edit" do
    get edit_district_datum_url(@district_datum)
    assert_response :success
  end

  test "should update district_datum" do
    patch district_datum_url(@district_datum), params: { district_datum: { direct_competitors: @district_datum.direct_competitors, float,: @district_datum.float,, indirect_competitors: @district_datum.indirect_competitors, name: @district_datum.name, population: @district_datum.population, public_trans_lvl: @district_datum.public_trans_lvl, purchasing_power: @district_datum.purchasing_power, rent_index: @district_datum.rent_index, restaurant_price_index: @district_datum.restaurant_price_index, restaurant_type: @district_datum.restaurant_type, restaurant_type_num: @district_datum.restaurant_type_num, restaurants_avg_rating: @district_datum.restaurants_avg_rating, restaurants_price_avg_lvl: @district_datum.restaurants_price_avg_lvl, restaurants_sum_rating: @district_datum.restaurants_sum_rating } }
    assert_redirected_to district_datum_url(@district_datum)
  end

  test "should destroy district_datum" do
    assert_difference('DistrictDatum.count', -1) do
      delete district_datum_url(@district_datum)
    end

    assert_redirected_to district_data_url
  end
end
