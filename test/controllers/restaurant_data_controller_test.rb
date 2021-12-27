require "test_helper"

class RestaurantDataControllerTest < ActionDispatch::IntegrationTest
  setup do
    @restaurant_datum = restaurant_data(:one)
  end

  test "should get index" do
    get restaurant_data_url
    assert_response :success
  end

  test "should get new" do
    get new_restaurant_datum_url
    assert_response :success
  end

  test "should create restaurant_datum" do
    assert_difference('RestaurantDatum.count') do
      post restaurant_data_url, params: { restaurant_datum: { city: @restaurant_datum.city, name: @restaurant_datum.name, rating: @restaurant_datum.rating } }
    end

    assert_redirected_to restaurant_datum_url(RestaurantDatum.last)
  end

  test "should show restaurant_datum" do
    get restaurant_datum_url(@restaurant_datum)
    assert_response :success
  end

  test "should get edit" do
    get edit_restaurant_datum_url(@restaurant_datum)
    assert_response :success
  end

  test "should update restaurant_datum" do
    patch restaurant_datum_url(@restaurant_datum), params: { restaurant_datum: { city: @restaurant_datum.city, name: @restaurant_datum.name, rating: @restaurant_datum.rating } }
    assert_redirected_to restaurant_datum_url(@restaurant_datum)
  end

  test "should destroy restaurant_datum" do
    assert_difference('RestaurantDatum.count', -1) do
      delete restaurant_datum_url(@restaurant_datum)
    end

    assert_redirected_to restaurant_data_url
  end
end
