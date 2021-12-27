require "application_system_test_case"

class RestaurantDataTest < ApplicationSystemTestCase
  setup do
    @restaurant_datum = restaurant_data(:one)
  end

  test "visiting the index" do
    visit restaurant_data_url
    assert_selector "h1", text: "Restaurant Data"
  end

  test "creating a Restaurant datum" do
    visit restaurant_data_url
    click_on "New Restaurant Datum"

    fill_in "City", with: @restaurant_datum.city
    fill_in "Name", with: @restaurant_datum.name
    fill_in "Rating", with: @restaurant_datum.rating
    click_on "Create Restaurant datum"

    assert_text "Restaurant datum was successfully created"
    click_on "Back"
  end

  test "updating a Restaurant datum" do
    visit restaurant_data_url
    click_on "Edit", match: :first

    fill_in "City", with: @restaurant_datum.city
    fill_in "Name", with: @restaurant_datum.name
    fill_in "Rating", with: @restaurant_datum.rating
    click_on "Update Restaurant datum"

    assert_text "Restaurant datum was successfully updated"
    click_on "Back"
  end

  test "destroying a Restaurant datum" do
    visit restaurant_data_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Restaurant datum was successfully destroyed"
  end
end
