class MapsController < ApplicationController
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
    
  end

  def lad_heatmap
    gon.form_token = form_authenticity_token
    
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
