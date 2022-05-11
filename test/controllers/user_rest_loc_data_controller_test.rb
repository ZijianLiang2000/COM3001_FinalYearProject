require "test_helper"

class UserRestLocDataControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user_rest_loc_datum = user_rest_loc_data(:one)
  end

  test "should get index" do
    get user_rest_loc_data_url
    assert_response :success
  end

  test "should get new" do
    get new_user_rest_loc_datum_url
    assert_response :success
  end

  test "should create user_rest_loc_datum" do
    assert_difference('UserRestLocDatum.count') do
      post user_rest_loc_data_url, params: { user_rest_loc_datum: { cluster_name: @user_rest_loc_datum.cluster_name, lad_name: @user_rest_loc_datum.lad_name, lat: @user_rest_loc_datum.lat, long: @user_rest_loc_datum.long, lsoa_name: @user_rest_loc_datum.lsoa_name, rest_cat: @user_rest_loc_datum.rest_cat, score: @user_rest_loc_datum.score, user: @user_rest_loc_datum.user } }
    end

    assert_redirected_to user_rest_loc_datum_url(UserRestLocDatum.last)
  end

  test "should show user_rest_loc_datum" do
    get user_rest_loc_datum_url(@user_rest_loc_datum)
    assert_response :success
  end

  test "should get edit" do
    get edit_user_rest_loc_datum_url(@user_rest_loc_datum)
    assert_response :success
  end

  test "should update user_rest_loc_datum" do
    patch user_rest_loc_datum_url(@user_rest_loc_datum), params: { user_rest_loc_datum: { cluster_name: @user_rest_loc_datum.cluster_name, lad_name: @user_rest_loc_datum.lad_name, lat: @user_rest_loc_datum.lat, long: @user_rest_loc_datum.long, lsoa_name: @user_rest_loc_datum.lsoa_name, rest_cat: @user_rest_loc_datum.rest_cat, score: @user_rest_loc_datum.score, user: @user_rest_loc_datum.user } }
    assert_redirected_to user_rest_loc_datum_url(@user_rest_loc_datum)
  end

  test "should destroy user_rest_loc_datum" do
    assert_difference('UserRestLocDatum.count', -1) do
      delete user_rest_loc_datum_url(@user_rest_loc_datum)
    end

    assert_redirected_to user_rest_loc_data_url
  end
end
