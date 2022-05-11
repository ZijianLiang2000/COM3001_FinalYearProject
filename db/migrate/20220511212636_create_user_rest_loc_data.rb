class CreateUserRestLocData < ActiveRecord::Migration[6.1]
  def change
    create_table :user_rest_loc_data do |t|
      t.belongs_to :user, index: true, foreign_key: true
      t.string :lsoa_code, :null => false
      t.string :lad_name, :null => false
      t.string :lat, :null => false
      t.string :long, :null => false
      t.string :rest_cat, :null => false
      t.integer :score, :null => false
      t.timestamps
    end
  end
end
