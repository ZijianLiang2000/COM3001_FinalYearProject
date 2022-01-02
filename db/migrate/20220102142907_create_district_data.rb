class CreateDistrictData < ActiveRecord::Migration[6.1]
  def change
    create_table :district_data do |t|
      t.string :name, null: false
      t.string :restaurant_type, null: false
      t.integer :restaurant_type_num, null: false
      t.string :restaurants_avg_rating, null: false
      t.integer :population, null: false
      t.integer :restaurants_sum_rating, null: false
      t.integer :restaurants_price_avg_lvl, null: false
      t.integer :public_trans_lvl
      t.integer :direct_competitors, null: false
      t.integer :indirect_competitors, null: false
      t.integer :purchasing_power
      t.float :restaurant_price_index
      t.float :rent_index

      t.timestamps
    end
  end
end
