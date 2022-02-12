class CreateRestaurantData < ActiveRecord::Migration[6.1]
  def change
    create_table :restaurant_data do |t|
      t.belongs_to :DistrictDatum
      t.string :url, null: false
      t.string :category, null: false
      t.string :place_id, null: false
      t.string :comment
      t.string :name
      t.float :rating
      t.string :lat
      t.string :lng

      t.timestamps
    end
  end
end
