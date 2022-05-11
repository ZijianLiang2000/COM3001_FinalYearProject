require "application_system_test_case"

class UserRestLocDataTest < ApplicationSystemTestCase
  setup do
    @user_rest_loc_datum = user_rest_loc_data(:one)
  end

  test "visiting the index" do
    visit user_rest_loc_data_url
    assert_selector "h1", text: "User Rest Loc Data"
  end

  test "creating a User rest loc datum" do
    visit user_rest_loc_data_url
    click_on "New User Rest Loc Datum"

    fill_in "Cluster name", with: @user_rest_loc_datum.cluster_name
    fill_in "Lad name", with: @user_rest_loc_datum.lad_name
    fill_in "Lat", with: @user_rest_loc_datum.lat
    fill_in "Long", with: @user_rest_loc_datum.long
    fill_in "Lsoa name", with: @user_rest_loc_datum.lsoa_name
    fill_in "Rest cat", with: @user_rest_loc_datum.rest_cat
    fill_in "Score", with: @user_rest_loc_datum.score
    fill_in "User", with: @user_rest_loc_datum.user
    click_on "Create User rest loc datum"

    assert_text "User rest loc datum was successfully created"
    click_on "Back"
  end

  test "updating a User rest loc datum" do
    visit user_rest_loc_data_url
    click_on "Edit", match: :first

    fill_in "Cluster name", with: @user_rest_loc_datum.cluster_name
    fill_in "Lad name", with: @user_rest_loc_datum.lad_name
    fill_in "Lat", with: @user_rest_loc_datum.lat
    fill_in "Long", with: @user_rest_loc_datum.long
    fill_in "Lsoa name", with: @user_rest_loc_datum.lsoa_name
    fill_in "Rest cat", with: @user_rest_loc_datum.rest_cat
    fill_in "Score", with: @user_rest_loc_datum.score
    fill_in "User", with: @user_rest_loc_datum.user
    click_on "Update User rest loc datum"

    assert_text "User rest loc datum was successfully updated"
    click_on "Back"
  end

  test "destroying a User rest loc datum" do
    visit user_rest_loc_data_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "User rest loc datum was successfully destroyed"
  end
end
