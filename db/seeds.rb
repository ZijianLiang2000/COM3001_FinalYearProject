# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'csv'

# Request api providing API URI and Key 
def request_api(url)
    response = Excon.get(
        url,
        headers: {
        'X-RapidAPI-Host' => URI.parse(url).host,
        'X-RapidAPI-Key' => ENV["API_KEY"]
        }
    )
    return nil if response.status != 200
    JSON.parse(response.body)
end

# Request API method for available districts with CoL information
def request_api_col(url,district_name)
    response = Excon.post(
        url,
        body: 'cities=%5B%7B%22name%22%3A%22'+ URI.encode(district_name) +'%22%2C%22country%22%3A%22United%20Kingdom%22%7D%5D&currencies=%5B%22USD%22%5D',
        headers: {
        'content-type' => 'application/x-www-form-urlencoded',
        'x-rapidapi-host' => URI.parse(url).host,
        'x-rapidapi-key' => ENV["API_KEY"]
        }

    )
    return nil if response.status != 200
    JSON.parse(response.body)
    
  end


# Get latitude and longitude of each LAD
CSV.foreach(Rails.root.join('lib\Local_Authority_Name.csv'), headers: true) do |row|

    puts("Name: " + (row[0]).to_s + ", lat: " + (row[2]).to_s + ", lng:" + (row[1]).to_s + "\n")
    
    # Verify if name is empty, if not store lat and lng data to db
    unless row[0].to_s.strip.empty?
        DistrictDatum.create({
            name: row[0].to_s,
            longitude: row[1].to_s,
            latitude: row[2].to_s
        })
    end
end
 
    # Get cost of living data of each district on map
CSV.foreach(Rails.root.join('lib\Cost_of_Living_Districts.csv'), headers: true) do |row|

  district_name = row[0].to_s

  puts("Name: " + district_name + "\n")

  # Retreive available cost of living detail of cities
  cost_of_living = request_api_col(
    "https://cities-cost-of-living1.p.rapidapi.com/get_cities_details_by_name",district_name
  )

  col_index = cost_of_living["data"][0]["cost_of_living_plus_rent_index"]
  restaurant_price_index = cost_of_living["data"][0]["restaurant_price_index"]
  rent_index = cost_of_living["data"][0]["rent_index"]
  purchasing_power = cost_of_living["data"][0]["local_purchasing_power_index"]
  puts("COL index:" + col_index.to_s + "\n")
  puts("restaurant_price_index:" + restaurant_price_index.to_s + "\n")

  district_name_pair = ""

  if district_name == "London":
    district_name_pair = "City of London"
  else
    district_name_pair = district_name
  end

  puts("Name Pair: " + district_name_pair + "\n")
  district = DistrictDatum.where(name:district_name_pair)
  district.update(restaurant_price_index: restaurant_price_index, rent_index: rent_index, purchasing_power: purchasing_power)

end

