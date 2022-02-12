# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'csv'
require 'json'

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

# Initialize faster import arrays for district
district_column = [:code, :name, :population]
district_column_values = []

# Get data for each LAD
CSV.foreach(Rails.root.join('lib\Local_Authority_Name.csv'), headers: true) do |row|

  # Verify if name is empty, if not store lat and lng data to db
  if (row[0].to_s.strip.empty? || row[0].to_s.strip == "")
    break
  end

  puts("Code: " + (row[0]).to_s + ", Name: " + (row[1]).to_s + ", Population: " + (row[2]).to_s + "\n")

  unless row[1].to_s.strip.empty?

    # import code, name and population to array
    district_column_values << [row[0].to_s, row[1].to_s, row[2].to_i]

  end
end

# Faster import data from district array into sqlite
ActiveRecord::Base.transaction do
  DistrictDatum.import district_column, district_column_values
  district_column_values.clear()
end

# Get cost of living data of each district on map
CSV.foreach(Rails.root.join('lib\Cost_of_Living_Districts.csv'), headers: true) do |row|

  # Check if empty
  if (row[0].to_s.strip.empty? || row[0].to_s.strip == "")
    break
  end

  district_name = row[0].to_s

  puts("Name: " + district_name + ", Inputting COL relavant data\n")

  restaurant_price_index = row[2].to_f
  rent_index = row[3].to_f
  purchasing_power = row[1].to_i

  district = DistrictDatum.where(name: district_name)
  district.update(restaurant_price_index: restaurant_price_index, rent_index: rent_index, purchasing_power: purchasing_power)

end
  
# Obtain json data for different categories of restaurants in all LADs
dict_file = File.read('lib/dict.json')
# Parsing the file into hash
data_hash = JSON.parse(dict_file)
# Initialize array to store LAD codes and names
ladCodes = Array.new
ladNames = Array.new

# Get latitude and longitude of each LAD
CSV.foreach(Rails.root.join('lib\Local_Authority_Name.csv'), headers: true) do |row|
  # Verify if name is empty, if not store lat and lng data to db
  unless row[1].to_s.strip.empty?
    ladCodes.append(row[0].to_s)
    # Replace space in LAD names to be "_" to match URL
    if row[1].to_s.include? " "
      ladNames.append(row[1].to_s.gsub(" ", "_"))
    else
      ladNames.append(row[1].to_s)
    end
  end
end

loop_count = 0

# Initialize faster import arrays
restaurant_column = [:url, :category, :place_id, :DistrictDatum_id]
restaurant_column_values = []

lad_id = 1
for ladName in ladNames do
  puts "ladName: #{ladName}"
  #For each restaurant category in this LAD area
  data_hash[ladName].each do |restaurant_cat|
    category = restaurant_cat[0]
    all_url = data_hash[ladName][restaurant_cat[0]]
    # For each url, add as an instance with parameters assigned
    for url in all_url do
      # break loop if done
      place_id = url.partition('query_place_id=').last

      loop_count += 1
      # puts "url: #{url}"
      # obtain place_id in url:
      puts "\n -------- Iteration: #{loop_count}, #{((loop_count.to_f)/191102).round(3)*100}% --------\n\n"
      
      # Switch LAD name and category containing "_" back to " "
      # Add restaurant data (name containing "_" to " ")
      ladNameStr = ladName.gsub("_"," ")
      categoryStr = category.gsub("_"," ")

      puts "ladName: #{ladNameStr}"
      puts "place_id: #{place_id}"
      puts "category: #{categoryStr}"
      puts "url: #{url}"
      district_datum_id = lad_id
      puts "district_datum_id: #{district_datum_id}"
      restaurant_column_values << [url, categoryStr, place_id, district_datum_id]
      
    end
  end

  lad_id += 1

end

# Faster import data from restaurant array into sqlite
ActiveRecord::Base.transaction do
  RestaurantDatum.import restaurant_column, restaurant_column_values
  restaurant_column_values.clear()
end

puts "DONE!!"