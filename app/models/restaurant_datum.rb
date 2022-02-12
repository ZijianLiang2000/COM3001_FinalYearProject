class RestaurantDatum < ApplicationRecord
    belongs_to :DistrictDatum

    Restaurant_Category_Encode = ["Italian Restaurant","Indian Restaurant","Japanese Restaurant","Thai Restaurant","British Restaurant","Chinese Restaurant","Vegetarian","Cafe","Pub"]
    
end
