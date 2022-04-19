class MapsController < ApplicationController
  require 'csv'
  require 'uri'
  before_action :set_map, only: %i[ show edit update destroy ]

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
    puts("received LAD Name: " + name)
    puts("received LAD 2020 Code: " + lad20_code)
    puts("received LAD Map Style: " + map_style)
    puts("received LAD Restaurant Category: " + rest_cat)
 
    @map_style = map_style
    @rest_cat = rest_cat
    @lad_name = name
    @lad20_code = lad20_code
    

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

  end

  def lad_heatmap
    gon.form_token = form_authenticity_token
    rest_cat = params[:rest_cat_value]
    price_seg = params[:price_seg_value]
    acceptance_select = params[:acceptance_value]

    rest_cat_arr = ["Italian Restaurant","Indian Restaurant","Japanese Restaurant","Thai Restaurant","British Restaurant","Chinese Restaurant","Vegetarian","Cafe","Pub"];

    puts("Restaurant Index: " + rest_cat_arr.index((rest_cat).to_s).to_s)
    @rest_cat = rest_cat_arr.index((rest_cat).to_s) + 1
    gon.rest_cat = rest_cat_arr.index((rest_cat).to_s) + 1
    puts("Restaurant Category: " + (rest_cat).to_s)
    puts("Price Segment: " + (price_seg).to_s)
    puts("Acceptance Select: " + (acceptance_select).to_s)
  end

  def rest_cluster
    name = params[:name]
    code = params[:code]
    rest_cat = params[:rest_cat]
    puts("received LSOA name: " + name)
    puts("received LSOA code: " + code)
    puts("received restaurant category: " + rest_cat)
    
    @lsoa11_name = name
    @lsoa11_code = code
    @rest_cat = rest_cat


    gon.lsoa11_name = name
    gon.lsoa11_code = code
    gon.rest_cat = rest_cat
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


  def nearby_result
    if(params[:lat] == nil || params[:lat] == "" || params[:lng] == nil || params[:lng] == "")
      redirect_to :back, alert: "Latitude and Longitude is empty, please try another place"
      return
    end

    lat = params[:lat]
    lng = params[:lng]
    
    puts("Latitude:" + lat + "Longitude:" + lng)

    nearby = request_api(
      "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=#{URI.encode(lat)}%2C#{URI.encode(lng)}&radius=5000&type=restaurant&keyword=&key=#{ENV["GOOGLE_API_KEY"]}"
    )

    if(nearby["results"][0] == nil)
      redirect_to lsoa_heatmap_path, alert: "Nearby info not found"
      return
    end

    @nearby_results = nearby
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

    # Use callbacks to share common setup or constraints between actions.
    def set_map
      @map = Map.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def map_params
      params.require(:map).permit(:name, :style)
    end
end
