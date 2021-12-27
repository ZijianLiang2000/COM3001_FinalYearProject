class RestaurantDataController < ApplicationController
  before_action :set_restaurant_datum, only: %i[ show edit update destroy ]

  # GET /restaurant_data or /restaurant_data.json
  def index
    @restaurant_data = RestaurantDatum.all
  end

  # GET /restaurant_data/1 or /restaurant_data/1.json
  def show
  end

  # GET /restaurant_data/new
  def new
    @restaurant_datum = RestaurantDatum.new
  end

  # GET /restaurant_data/1/edit
  def edit
  end

  def result
    # (lat,lng,limit,dist_radius)
    address = params[:address]

    limit = params[:limit]
    dist_radius = params[:dist_radius]

    address_coord = request_api(
      "https://google-maps-geocoding.p.rapidapi.com/geocode/json?address=#{URI.encode(address)}&language=en"
    )
    
    # if(address_coord) does not respond anything
    if(address_coord["results"][0] == nil)
      redirect_to restaurant_search_path, alert: "Address not found"
      return
    end
    
    # If there is a boundary of coordinates available for the address and restaurants available within the boundary
    if(address_coord["results"][0]["geometry"]["bounds"] != nil && request_api(
      "https://travel-advisor.p.rapidapi.com/restaurants/list-in-boundary?bl_latitude=#{URI.encode(address_coord["results"][0]["geometry"]["bounds"]["southwest"]["lat"].to_s)} \
      &tr_latitude=#{URI.encode(address_coord["results"][0]["geometry"]["bounds"]["northeast"]["lat"].to_s)} \
      &bl_longitude=#{URI.encode(address_coord["results"][0]["geometry"]["bounds"]["southwest"]["lng"].to_s)} \
      &tr_longitude=#{URI.encode(address_coord["results"][0]["geometry"]["bounds"]["northeast"]["lng"].to_s)} \
      &limit=#{URI.encode(limit)}&currency=GBP&distance=#{URI.encode(dist_radius)}&lunit=km&lang=en_US"
    )["data"].first != nil)

      northEast_lat = address_coord["results"][0]["geometry"]["bounds"]["northeast"]["lat"].to_s
      northEast_lng = address_coord["results"][0]["geometry"]["bounds"]["northeast"]["lng"].to_s
      southWest_lat = address_coord["results"][0]["geometry"]["bounds"]["southwest"]["lat"].to_s
      southWest_lng = address_coord["results"][0]["geometry"]["bounds"]["southwest"]["lng"].to_s

      puts("tr_lat: " + northEast_lat + ", tr_lng: " + northEast_lng + ", bl_lat: " + southWest_lat + ", bl_lng: " + southWest_lng)

      restaurant_results = request_api(
        "https://travel-advisor.p.rapidapi.com/restaurants/list-in-boundary?bl_latitude=#{URI.encode(southWest_lat)}&tr_latitude=#{URI.encode(northEast_lat)}&bl_longitude=#{URI.encode(southWest_lng)}&tr_longitude=#{URI.encode(northEast_lng)}&limit=#{URI.encode(limit)}&currency=GBP&distance=#{URI.encode(dist_radius)}&lunit=km&lang=en_US"
      )
      puts("RESTAURANT DATA URL: " + restaurant_results["data"].first["location_id"])

    elsif(address_coord["results"][0]["geometry"]["location"] != nil)
      # If no boundary available for address or no restaurants available within the boundary, just use one coordinate
      lat = address_coord["results"][0]["geometry"]["location"]["lat"].to_s
      lng = address_coord["results"][0]["geometry"]["location"]["lng"].to_s
      restaurant_results = request_api(
        "https://travel-advisor.p.rapidapi.com/restaurants/list-by-latlng?latitude=#{URI.encode(lat)}&longitude=#{URI.encode(lng)}&limit=#{URI.encode(limit)}&currency=GBP&distance=#{URI.encode(dist_radius)}&lunit=km&lang=en_US"
      )
      puts("restaurant:" + restaurant_results["data"].first["location_id"])
    else
      redirect_to restaurant_search_path, alert: "Address not found"
      return
    end

    @restaurants = restaurant_results

    if @restaurants["data"] == nil
      # flash[:alert] = 'No restaurants available, please try again'
      redirect_to restaurant_search_path, alert: "Restaurant info nearby not found for address"
      return
    end

  end

  # POST /restaurant_data or /restaurant_data.json
  def create
    @restaurant_datum = RestaurantDatum.new(restaurant_datum_params)

    respond_to do |format|
      if @restaurant_datum.save
        format.html { redirect_to @restaurant_datum, notice: "Restaurant datum was successfully created." }
        format.json { render :show, status: :created, location: @restaurant_datum }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @restaurant_datum.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /restaurant_data/1 or /restaurant_data/1.json
  def update
    respond_to do |format|
      if @restaurant_datum.update(restaurant_datum_params)
        format.html { redirect_to @restaurant_datum, notice: "Restaurant datum was successfully updated." }
        format.json { render :show, status: :ok, location: @restaurant_datum }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @restaurant_datum.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /restaurant_data/1 or /restaurant_data/1.json
  def destroy
    @restaurant_datum.destroy
    respond_to do |format|
      format.html { redirect_to restaurant_data_url, notice: "Restaurant datum was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

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
    def set_restaurant_datum
      @restaurant_datum = RestaurantDatum.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def restaurant_datum_params
      params.require(:restaurant_datum).permit(:city, :name, :rating)
    end
end
