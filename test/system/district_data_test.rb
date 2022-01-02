require "application_system_test_case"

class DistrictDataTest < ApplicationSystemTestCase
  setup do
    @district_datum = district_data(:one)
  end

  test "visiting the index" do
    visit district_data_url
    assert_selector "h1", text: "District Data"
  end

  test "creating a District datum" do
    visit district_data_url
    click_on "New District Datum"

    fill_in "Direct competitors", with: @district_datum.direct_competitors
    fill_in "Float,", with: @district_datum.float,
    fill_in "Indirect competitors", with: @district_datum.indirect_competitors
    fill_in "Name", with: @district_datum.name
    fill_in "Population", with: @district_datum.population
    fill_in "Public trans lvl", with: @district_datum.public_trans_lvl
    fill_in "Purchasing power", with: @district_datum.purchasing_power
    fill_in "Rent index", with: @district_datum.rent_index
    fill_in "Restaurant price index", with: @district_datum.restaurant_price_index
    fill_in "Restaurant type", with: @district_datum.restaurant_type
    fill_in "Restaurant type num", with: @district_datum.restaurant_type_num
    fill_in "Restaurants avg rating", with: @district_datum.restaurants_avg_rating
    fill_in "Restaurants price avg lvl", with: @district_datum.restaurants_price_avg_lvl
    fill_in "Restaurants sum rating", with: @district_datum.restaurants_sum_rating
    click_on "Create District datum"

    assert_text "District datum was successfully created"
    click_on "Back"
  end

  test "updating a District datum" do
    visit district_data_url
    click_on "Edit", match: :first

    fill_in "Direct competitors", with: @district_datum.direct_competitors
    fill_in "Float,", with: @district_datum.float,
    fill_in "Indirect competitors", with: @district_datum.indirect_competitors
    fill_in "Name", with: @district_datum.name
    fill_in "Population", with: @district_datum.population
    fill_in "Public trans lvl", with: @district_datum.public_trans_lvl
    fill_in "Purchasing power", with: @district_datum.purchasing_power
    fill_in "Rent index", with: @district_datum.rent_index
    fill_in "Restaurant price index", with: @district_datum.restaurant_price_index
    fill_in "Restaurant type", with: @district_datum.restaurant_type
    fill_in "Restaurant type num", with: @district_datum.restaurant_type_num
    fill_in "Restaurants avg rating", with: @district_datum.restaurants_avg_rating
    fill_in "Restaurants price avg lvl", with: @district_datum.restaurants_price_avg_lvl
    fill_in "Restaurants sum rating", with: @district_datum.restaurants_sum_rating
    click_on "Update District datum"

    assert_text "District datum was successfully updated"
    click_on "Back"
  end

  test "destroying a District datum" do
    visit district_data_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "District datum was successfully destroyed"
  end
end
