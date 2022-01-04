class ApplicationController < ActionController::Base
    before_action :assign_env_variables
    helper_method :get_detailed_addr

    def get_detailed_addr(place_id)
        puts("PLACE_ID!: " + place_id)
        restaurant_addr_detail = request_api("https://maps.googleapis.com/maps/api/place/details/json?place_id=#{place_id}&key=#{ENV["GOOGLE_API_KEY"]}")
        @restaurant_address = restaurant_addr_detail["result"]["formatted_address"]
        return @restaurant_address
    end
    

    def assign_env_variables
        puts("RUNNING function")
        gon.google_api_key = ENV["GOOGLE_API_KEY"]
    end
end
