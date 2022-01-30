class CreateDistrictData < ActiveRecord::Migration[6.1]
  def change
    create_table :district_data do |t|
      t.string :name, null: false
      t.string :longitude, null: false
      t.string :latitude, null: false
      t.string :restaurant_type
      t.integer :restaurant_type_num
      t.string :restaurants_avg_rating
      t.integer :population
      t.integer :restaurants_sum_rating
      t.integer :restaurants_price_avg_lvl
      t.integer :public_trans_lvl
      t.integer :direct_competitors
      t.integer :indirect_competitors
      t.integer :purchasing_power
      t.float :restaurant_price_index
      t.float :rent_index

      t.timestamps
    end
  end
end
