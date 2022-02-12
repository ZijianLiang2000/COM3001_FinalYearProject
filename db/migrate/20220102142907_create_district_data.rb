class CreateDistrictData < ActiveRecord::Migration[6.1]
  def change
    create_table :district_data do |t|
      t.string :name, null: false
      t.string :code, null: false
      t.integer :population
      t.integer :public_trans_lvl
      t.integer :purchasing_power
      t.float :restaurant_price_index
      t.float :rent_index
      t.float :cost_of_food_supply
      t.float :employment_lvl
      t.float :rec_val

      t.timestamps
    end
  end
end
