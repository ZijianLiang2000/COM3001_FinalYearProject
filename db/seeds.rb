# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'csv'
require 'tempfile'
require 'fileutils'

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

    # Verify if name is empty, if not store lat and lng data to db
    if (row[0].to_s.strip.empty? || row[0].to_s.strip == "")
      break
    end

    puts("Code: " + (row[0]).to_s + ", Name: " + (row[1]).to_s + "\n")

    unless row[1].to_s.strip.empty?
        DistrictDatum.create({
            code: row[0].to_s,
            name: row[1].to_s,
        })
    end

end
 
old_csv = CSV.open('lib\Cost_of_Living_Districts.csv', "r", headers: true, return_headers: true)
old_csv.readline
temp = Tempfile.new
# Open the new CSV with the existing headers plus a new one.
new_csv = CSV.open(
  temp, "w",
  headers: old_csv.headers + [:new],
  write_headers: true
)


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

  if district_name == "London"
    district_name_pair = "City of London"
  elsif district_name == "Bournemouth"
    district_name_pair = "Bournemouth, Christchurch and Poole"
  elsif district_name == "Bristol"
    district_name_pair = "Bristol, City of"
  elsif district_name == "Brighton"
    district_name_pair = "Brighton and Hove"
  elsif district_name == "Kingston upon Hull"
    district_name_pair = "Kingston upon Hull, City of"
  else
    district_name_pair = district_name
  end

  puts("Name Pair: " + district_name_pair + "\n")
  district = DistrictDatum.where(name: district_name_pair)
  district.update(restaurant_price_index: restaurant_price_index, rent_index: rent_index, purchasing_power: purchasing_power)
  row[:cost_of_living_with_rent] = col_index
  row[:restaurant_price_index] = restaurant_price_index
  row[:rent_index] = rent_index
  row[:local_purchasing_power_index] = purchasing_power
  new_csv << row
end

new_csv.close

csv_file = 'lib\Cost_of_Living_Districts_Copy.csv'
# Replace the old CSV with the new one.
FileUtils.move(temp.path, csv_file)
