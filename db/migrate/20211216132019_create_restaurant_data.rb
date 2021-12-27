class CreateRestaurantData < ActiveRecord::Migration[6.1]
  def change
    create_table :restaurant_data do |t|
      t.string :city
      t.string :name
      t.float :rating

      t.timestamps
    end
  end
end
