class MapsController < ApplicationController
  require 'csv'
  require 'uri'
  require 'json'
  before_action :set_map, only: %i[ show edit update destroy ]
  before_action :dissolve, only: [ :user_option ]

  # GET /maps or /maps.json
  def index
    @maps = Map.all
  end

  # GET /maps/1 or /maps/1.json
  def show
  end

  # GET /maps/new
  def new
    @map = Map.new
  end

  # GET /maps/1/edit
  def edit
  end

  def lsoa_heatmap
    gon.form_token = form_authenticity_token
    name = params[:name]
    lad20_code = params[:lad]
    map_style = params[:map_style]
    rest_cat = params[:rest_cat]
    #  convert passed weight_arr to array
    weight_arr = params[:weight_arr].split(',')

    puts("weight_arr is: ")
    puts(weight_arr)

    if name != nil && (!name.nil?)

      puts("received LAD Name: " + name)
      puts("received LAD 2020 Code: " + lad20_code)
      puts("received LAD Map Style: " + map_style)
      puts("received LAD Restaurant Category: " + rest_cat)
  
      @map_style = map_style
      @rest_cat = rest_cat
      @lad_name = name
      @lad20_code = lad20_code
      @weight_arr = weight_arr
      

      # Find LSOA areas under LAD Name from csv
      lsoa_filter = []
      # Loop through all rows
      CSV.foreach(Rails.root.join('lib\LSOA11_WD20_LAD20_EW_LU.csv'), headers: true) do |row|
        # If LAD name exist in LAD row
        if(row[5].include? lad20_code)
          # Add corresponding LSOA of LAD
          puts("corresponding lsoa:" + row[1])
          lsoa_filter.append(row[1].to_s)
        end
      end

      gon.lsoa_filter = lsoa_filter
      gon.rest_cat = rest_cat
      gon.lad_name = name
      gon.lad20_code = lad20_code
      gon.google_api_key = ENV["GOOGLE_API_KEY"]
      gon.weight_arr = weight_arr
    else
      redirect_to lad_heatmap_path
    end
  end

  def lad_heatmap
    gon.form_token = form_authenticity_token
    rest_cat = params[:rest_cat_value]
    price_seg = params[:price_seg_value]
    puts("PRICE_SEG")
    puts(price_seg)
    acceptance_select = params[:acceptance_value]
    rent_min = params[:rent_min]
    rent_max = params[:rent_max]
    
    puts("Rent min: " + rent_min.to_s)
    puts("Rent max: " + rent_max.to_s)

    if rent_max == nil || rent_min == nil
      puts("Empty rent min and max, assign with session")
      rent_max = session["rent_max"]
      rent_min = session["rent_min"]
    end

    # Validate rent_max larger than rent_min
    if rent_max.to_i <= rent_min.to_i
      redirect_to user_option_path, alert: "Minimum Rental should not be larger or equal to Maximum Rental, Please try again."
    end

    rest_cat_arr = ["Italian Restaurant","Indian Restaurant","Japanese Restaurant","Thai Restaurant","British Restaurant","Chinese Restaurant","Vegetarian","Cafe","Pub"];

    puts("Restaurant Index: " + rest_cat_arr.index((rest_cat).to_s).to_s)
    # If restaurant category is selected
    if rest_cat != nil && (!rest_cat.nil?)
      puts("If selected in first load without reloading")
      @rest_cat = rest_cat_arr.index((rest_cat).to_s) + 1
      @price_seg = price_seg
      @acceptance_select = acceptance_select
      @rent_min = rent_min
      @rent_max = rent_max
      
      gon.rest_cat = rest_cat_arr.index((rest_cat).to_s) + 1
      gon.rest_cat = @rest_cat
      gon.price_seg = @price_seg
      gon.acceptance_select = @acceptance_select
      gon.rent_min = @rent_min
      gon.rent_max = @rent_max
      
      # Save to session so able to reload these in LAD
      session["rest_cat"] = rest_cat_arr.index((rest_cat).to_s) + 1
      session["price_seg"] = price_seg
      session["acceptance_select"] = acceptance_select
      session["rent_min"] = rent_min
      session["rent_max"] = rent_max
      
      puts("Rest cat exists")

      puts("Restaurant Category: " + (@rest_cat).to_s)
      puts("Price Segment: " + (@price_seg).to_s)
      puts("Acceptance Select: " + (@acceptance_select).to_s)
      puts("Rent min: " + (@rent_min).to_s)
      puts("Rent max: " + (@rent_max).to_s)
    else
      puts("If reloaded view use session variables")
      # If session is set
      if session["rest_cat"] != nil && (!session["rest_cat"].nil?)
        puts("Rest cat does not exists but applied from session")
        @rest_cat = session["rest_cat"]
        @price_seg = session["price_seg"]
        @acceptance_select = session["acceptance_select"]
        @rent_min = session["rent_min"]
        @rent_max = session["rent_max"]
        puts("Rest cat from session:")
        puts(@rest_cat)
        gon.rest_cat = @rest_cat
        gon.price_seg = @price_seg
        gon.acceptance_select = @acceptance_select
        gon.rent_min = @rent_min
        gon.rent_max = @rent_max
      else
        puts("Session does not exist")
        puts(session["rest_cat"])
        redirect_to user_option_path, alert: "User options not selected, please try again."
      end
    end
    
    puts("Restaurant Category: " + (@rest_cat).to_s)
    puts("Price Segment: " + (@price_seg).to_s)
    puts("Acceptance Select: " + (@acceptance_select).to_s)
    puts("Rent min: " + (@rent_min).to_s)
    puts("Rent max: " + (@rent_max).to_s)
  end

  def rest_cluster
    gon.form_token = form_authenticity_token
    name = params[:name]
    lad_name = params[:lad_name]
    code = params[:code]
    rest_cat = params[:rest_cat]
    price_seg_val = params[:price_seg_val]
    loc_strategy = params[:loc_strategy]

    puts("received LSOA name: " + name)
    puts("received LSOA code: " + code)
    puts("received restaurant category: " + rest_cat)
    
    @lsoa11_name = name
    @lsoa11_code = code
    @rest_cat = rest_cat
    @price_seg_val = price_seg_val
    @loc_strategy = loc_strategy

    gon.lsoa11_name = name
    gon.lsoa11_code = code
    gon.rest_cat = rest_cat
    gon.lad_name = lad_name
    gon.price_seg_val = price_seg_val
    gon.loc_strategy = loc_strategy

  end

  def location_in_cluster
    gon.form_token = form_authenticity_token
    rest_cat = params[:rest_cat]
    lad_name = params[:lad_name]
    lsoa11_code = params[:lsoa_code]
    cluster_id = params[:cluster]
    place_id_arr = params[:place_id_arr]
    loc_strategy = params[:loc_strategy]
    price_avg = params[:price_avg]
    rating_avg = params[:rating_avg]

    puts("Received params: " + rest_cat + ", " + lad_name + ", " + lsoa11_code)

    if(place_id_arr != nil)
      place_id_arr = place_id_arr.split(",")
      puts("place_id_arr: ")
      for place_id in place_id_arr
        puts(place_id)
      end
      @place_id_arr = place_id_arr
      gon.place_id_arr = place_id_arr
    end

    @lsoa11_code = lsoa11_code
    @lad_name = lad_name
    @rest_cat = rest_cat
    @cluster_id = cluster_id
    @loc_strategy = loc_strategy
    @price_avg = price_avg
    @rating_avg = rating_avg
    
    gon.lsoa11_code = lsoa11_code
    gon.rest_cat = rest_cat
    gon.lad_name = lad_name
    gon.cluster_id = cluster_id
    gon.loc_strategy = loc_strategy
    gon.price_avg = price_avg
    gon.rating_avg = rating_avg
    gon.google_api_key = ENV["GOOGLE_API_KEY"]

  end

  # All restaurant categories
  def get_restaurant_count
    name = params[:name]
    puts("received LAD: " + name)
    
    restaurant_Category_Encode = ["Italian Restaurant","Indian Restaurant","Japanese Restaurant","Thai Restaurant","British Restaurant","Chinese Restaurant","Vegetarian","Cafe","Pub"]
    restaurant_Category_Count = []
    for category in restaurant_Category_Encode
      puts("Category: #{category}")
      areaRestaurantCatCount = RestaurantDatum.where(DistrictDatum_id: DistrictDatum.where(name: name).ids.first, category: category).count
      puts("Running, count: #{areaRestaurantCatCount}")
      restaurant_Category_Count.append(areaRestaurantCatCount)
    end

    render json: { response: restaurant_Category_Count }
  end

  def get_rest_detail_in_cluster
    puts("get restaurant detail in cluster")
    
    place_id = (params[:place_id])
    max_index = 0

    i = 0

    reviews = []

    # obtain restaurant place id
    if place_id.length() > 3
      place_id = place_id[1..3]
    end

    for place_id in place_id
      p "place_id: " + place_id.to_s
      reviews.append(data=[])

      detail_result = request_api(
        "https://maps.googleapis.com/maps/api/place/details/json?placeid=#{place_id}&key=#{ENV["GOOGLE_API_KEY"]}&fields=name,price_level,reviews"
      )

      puts(detail_result["result"]["name"])
      puts(detail_result["result"]["reviews"])

      # Simulation of retreiving results of details
      begin  
        reviews[i] = {}
        reviews[i].store("name", detail_result["result"]["name"])
        reviews[i].store("place_id", place_id)
        # Retreive 1 to 5 reviews for each restaurant
        reviews[i].store("reviews", detail_result["result"]["reviews"])


      i += 1
      end
      
      # store retreived data as session
      # Save json to file for development purpose not wasting api quota
      File.open("E:\\zl00628_COM3001_Project\\Loreco\\app\\assets\\get_rest_detail_in_cluster.json","w") do |f|
        f.write(reviews.to_json)
      end

      reviews = JSON.parse(File.read("E:\\zl00628_COM3001_Project\\Loreco\\app\\assets\\get_rest_detail_in_cluster.json"))
    
    end
    
    # store retreived data as session
    puts("Done filling in restaurant data")
    render json: { response: [reviews] }
  end

  # Function for semantic analysis on reviews in cluster
  def absa_reviews
    p "Analyzing reviews"
    review_texts = params[:text]
    puts(review_texts)
    p "Done!!!"

    # Python script
    
    p "Running scrypt: "

    # request api
    # nethttp.rb
    require 'uri'
    require 'net/http'

    uri = URI(URI.encode("http://127.0.0.1:5000/absa/"+review_texts))
    puts(uri)
    res = Net::HTTP.get_response(uri)
    puts res.body if res.is_a?(Net::HTTPSuccess)

    
    result = JSON.parse(res.body)
    puts("Parsed json result:")
    puts(result["data"]["0"][0])

    p "Done Semantic"
    render json: { response: result }
  end


  def get_rest_detail
    puts("get_rest_detail")
    
    info_arr = (params[:info_arr])
    max_index = 0

    i = 0

    rest_details_arr = []

    # obtain restaurant place id
    
    for restaurant in info_arr
      p "Restaurant: " + i.to_s
        rest_details_arr.append([])
        for info in restaurant
          if info["2"] != nil && (!info["2"].nil?)
            if info["2"]["value"] != nil && (!info["2"]["value"].nil?)
              p "Restaurant data: "
              p info["2"]["value"]

              detail_result = request_api(
                "https://maps.googleapis.com/maps/api/place/details/json?placeid=#{info["2"]["value"]}&key=#{ENV["GOOGLE_API_KEY"]}&fields=name,price_level,rating"
              )

              puts(detail_result["result"]["name"])
              puts(info["2"]["value"])
              puts(info["3"]["value"])
              puts(detail_result["result"]["rating"])
              puts(detail_result["result"]["price_level"])

              # Simulation of retreiving results of details
              rest_details_arr[i] = {}
              rest_details_arr[i].store("name", detail_result["result"]["name"])
              rest_details_arr[i].store("place_id", info["2"]["value"])
              rest_details_arr[i].store("rest_cat", info["3"]["value"])
              rest_details_arr[i].store("rating", detail_result["result"]["rating"])
              rest_details_arr[i].store("price_level", detail_result["result"]["price_level"])
            end
          end
        end
      i += 1
    end
    
    # store retreived data as session
    # Save json to file for development purpose not wasting api quota
    # File.open("E:\\zl00628_COM3001_Project\\Loreco\\app\\assets\\get_rest_detail.json","w") do |f|
    #   f.write(rest_details_arr.to_json)
    # end

    #nearby_places = JSON.parse(File.read("E:\\zl00628_COM3001_Project\\Loreco\\app\\assets\\nearby_locations_temp_fs.json"))
    #puts(nearby_places["results"].length())

    # session[:rest_details_arr] = rest_details_arr
    
    # rest_details_arr = session[:rest_details_arr]

    puts("Done filling in restaurant data")
    render json: { response: rest_details_arr }
  end

  def result_page
    @place_id = params[:place_id]
    @lat=params[:lat]
    @long=params[:long]
    @lad_name=params[:lad_name]
    @loc_strategy=params[:loc_strategy]

    p @place_id
    p @lat
    p @long
    p @lad_name
    p @loc_strategy

    gon.place_id = @place_id
    gon.lat=@lat
    gon.long=@long
    gon.lad_name=@lad_name
    gon.loc_strategy=@loc_strategy
    
  end

  def nearby_result
    require 'json'
    require 'uri'
    require 'net/http'
    require 'openssl'

    if(params[:lat] == nil && params[:name] == nil)
      if(params[:map]=="LAD")
        redirect_back(fallback_location: lad_heatmap_path, allow_other_host: true, alert: "Input parameters not provided") 
        return
      elsif(params[:map]=="LSOA")
        redirect_back(fallback_location: lsoa_heatmap_path, allow_other_host: true, alert: "Input parameters not provided") 
        return
      end 
    end

    lat = params[:lat]
    lng = params[:lng]
    name = params[:name]
    map = params[:map]
    
    puts("Latitude:" + lat.to_s + ", Longitude:" + lng.to_s + ", Name:" + name.to_s)

    current_date = Time.now.strftime("%Y%m%d")
    puts(current_date)

    # Different attraction searched using Foursquare

    if(params[:name] != nil && params[:map]=="LAD")
      name = CGI.unescape(params[:name])
      puts("Searching nearby places by LAD Name")
      puts("https://api.foursquare.com/v3/places/search?near=#{name}, United Kingdom&categories=10000, 13000,19000,12009,16000,14000&fields=categories,geocodes,photos,price,rating,popularity,name,fsq_id,distance,location&sort=DISTANCE&limit=50")
      nearby_places = request_foursquare_api("https://api.foursquare.com/v3/places/search?near=#{name}, United Kingdom&categories=10000, 13000,19000,12009,16000,14000&fields=categories,geocodes,photos,price,rating,popularity,name,fsq_id,distance,location&sort=DISTANCE&limit=50")
    elsif(params[:lat] != nil && params[:map]=="LSOA")
      puts("Searching nearby places by LAD Latitude and Longitude")
      nearby_places = request_foursquare_api("https://api.foursquare.com/v3/places/search?ll=#{lat},#{lng}&categories=10000, 13000,19000,12009,16000,14000&fields=categories,geocodes,photos,price,rating,popularity,name,fsq_id,distance,location&sort=DISTANCE&limit=50&radius=2000")
      puts("https://api.foursquare.com/v3/places/search?ll=#{lat},#{lng}&categories=10000, 13000,19000,12009,16000,14000&fields=categories,geocodes,photos,price,rating,popularity,name,fsq_id,distance,location&sort=DISTANCE&limit=50&radius=2000")
    end

    # Save json to file for development purpose not wasting api quota
    File.open("E:\\zl00628_COM3001_Project\\Loreco\\app\\assets\\nearby_locations_temp_fs.json","w") do |f|
      f.write(nearby_places.to_json)
    end

    #nearby_places = JSON.parse(File.read("E:\\zl00628_COM3001_Project\\Loreco\\app\\assets\\nearby_locations_temp_fs.json"))
    #puts(nearby_places["results"].length())

    if(nearby_places["results"] == nil)
      if(params[:map]=="LAD")
        redirect_back(fallback_location: lad_heatmap_path, allow_other_host: true, alert: "No results returned") 
        return
      elsif(params[:map]=="LSOA")
        redirect_back(fallback_location: lsoa_heatmap_path, allow_other_host: true, alert: "No results returned") 
        return
      end
    end

    @nearby_results = nearby_places
    @place_lat = lat
    @place_lng = lng
    @map = map
    gon.nearby_places = nearby_places
    gon.place_lat = lat
    gon.place_lng = lng
  end

  # POST /maps or /maps.json
  def create
    @map = Map.new(map_params)

    respond_to do |format|
      if @map.save
        format.html { redirect_to @map, notice: "Map was successfully created." }
        format.json { render :show, status: :created, location: @map }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @map.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /maps/1 or /maps/1.json
  def update
    respond_to do |format|
      if @map.update(map_params)
        format.html { redirect_to @map, notice: "Map was successfully updated." }
        format.json { render :show, status: :ok, location: @map }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @map.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /maps/1 or /maps/1.json
  def destroy
    @map.destroy
    respond_to do |format|
      format.html { redirect_to maps_url, notice: "Map was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

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

    def request_foursquare_api(url)
      require 'uri'
      require 'net/http'
      require 'openssl'

      url = URI(URI.parse(url))

      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true

      request = Net::HTTP::Get.new(url)
      request["Accept"] = 'application/json'
      request["Authorization"] = ENV["FOURSQUARE_TOKEN"]

      response = http.request(request)
      return nil if response.body.nil?
      puts(response.read_body)
      JSON.parse(response.read_body)
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_map
      @map = Map.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def map_params
      params.require(:map).permit(:name, :style)
    end
end
