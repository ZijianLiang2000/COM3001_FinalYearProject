class DistrictDatum < ApplicationRecord
    require "csv"
    has_many :RestaurantData

    ladCodes = Array.new
    ladNames = Array.new

    # Get latitude and longitude of each LAD
    CSV.foreach(Rails.root.join('lib\Local_Authority_Name.csv'), headers: true) do |row|
        # Verify if name is empty, if not store lat and lng data to db
        if (row[0].to_s.strip.empty? || row[0].to_s.strip == "")
            break
        end
        unless row[1].to_s.strip.empty?
            ladCodes.append(row[0].to_s)
            ladNames.append(row[1].to_s)
        end
    end
    validates :name, presence: true, inclusion: { in: ladNames, message: "%{value} is not a valid Local Authority District Name" }
    validates :code, presence: true, inclusion: { in: ladCodes, message: "%{value} is not a valid Local Authority District Code" }

    # All restaurant categories
    Restaurant_Category_Encode = ["Italian Restaurant","Indian Restaurant","Japanese Restaurant","Thai Restaurant","British Restaurant","Chinese Restaurant","Vegetarian","Cafe","Pub"]
    districtName = self.name
    # for category in Restaurant_Category_Encode
    #     DistrictDatum.where(name: districtName).restaurantData

end
