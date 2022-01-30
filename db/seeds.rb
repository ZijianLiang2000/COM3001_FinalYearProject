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

# Get cost of living data of each district on map
CSV.foreach(Rails.root.join('lib\Local_Authority_Name.csv'), headers: true) do |row|

    puts("Name: " + (row[0]).to_s + ", lat: " + (row[2]).to_s + ", lng:" + (row[1]).to_s + "\n")
    
    # Verify if name is empty, if not store lat and lng data to db
    unless row[0].to_s.strip.empty?
        DistrictDatum.create({
            name: row[0].to_s,
            longitude: [1].to_s,
            latitude: [2].to_s
        })
    end


end