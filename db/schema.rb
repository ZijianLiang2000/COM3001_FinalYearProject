# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2022_01_02_142907) do

  create_table "district_data", force: :cascade do |t|
    t.string "name", null: false
    t.string "code", null: false
    t.integer "population"
    t.integer "public_trans_lvl"
    t.integer "purchasing_power"
    t.float "restaurant_price_index"
    t.float "rent_index"
    t.float "cost_of_food_supply"
    t.float "employment_lvl"
    t.float "rec_val"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "maps", force: :cascade do |t|
    t.string "name"
    t.string "style"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "restaurant_data", force: :cascade do |t|
    t.integer "DistrictDatum_id"
    t.string "url", null: false
    t.string "category", null: false
    t.string "place_id", null: false
    t.string "comment"
    t.string "name"
    t.float "rating"
    t.string "lat"
    t.string "lng"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["DistrictDatum_id"], name: "index_restaurant_data_on_DistrictDatum_id"
  end

end
