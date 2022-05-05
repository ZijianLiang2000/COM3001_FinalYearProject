class ApplicationController < ActionController::Base
    protect_from_forgery with: :exception
    include SessionsHelper
    before_action :assign_env_variables
    before_action :capture_path
    before_action :url_path
    helper_method :url_path, :get_detailed_addr, :filter_location_category

    # Helper function to get detailed address for place_id
    def get_detailed_addr(place_id)
        puts("PLACE_ID!: " + place_id)
        restaurant_addr_detail = request_api("https://maps.googleapis.com/maps/api/place/details/json?place_id=#{place_id}&key=#{ENV["GOOGLE_API_KEY"]}")
        @restaurant_address = restaurant_addr_detail["result"]["formatted_address"]
        return @restaurant_address
    end

    # Get current path
    def url_path
        current_path = request.original_url
        puts("Printing URL path")
        puts(current_path)
        progress = "0"
        case
        when current_path.include?('user_option')
            puts("Current path is user option view")
            progress = "20"
            puts(progress)
        when current_path.include?('lad_heatmap')
            puts('Current path is lad_heatmap view')
            progress = "40"
            puts(progress)
        when current_path.include?('lsoa_heatmap')
            puts('Current path is lsoa_heatmap view')
            progress = "60"
            puts(progress)
        when current_path.include?('rest_cluster')
            puts('Current path is rest_cluster view')
            progress = "80"
            puts(progress)
        when current_path.include?('location_in_cluster')
            puts('Current path is location_in_cluster view')
            progress = "90"
            puts(progress)
    
        else
        puts("Selected Other paths")

        end

        return progress
    end
    
    def filter_location_category(array)
        puts("Received array in helper function")
        puts(array)
    end

    def assign_env_variables
        puts("assigned google env var")
        gon.google_api_key = ENV["GOOGLE_API_KEY"]
    end
end
