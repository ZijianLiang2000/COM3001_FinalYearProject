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
    lat = params[:lat]
    lng = params[:lng]
    limit = params[:limit]
    dist_radius = params[:dist_radius]



    results = request_api(
      "https://travel-advisor.p.rapidapi.com/restaurants/list-by-latlng?latitude=#{URI.encode(lat)}&longitude=#{URI.encode(lng)}&limit=#{URI.encode(limit)}&currency=GBP&distance=#{URI.encode(dist_radius)}&lunit=km&lang=en_US"
    )
    puts("restaurant:" + results["data"].first["location_id"])
    @restaurants = results

    if @restaurants == nil
      flash[:alert] = 'No restaurants available, please try again'
      return render action: :search
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
        'X-RapidAPI-Key' => '81f17623camshd2b99a09f5ec7b9p1cf6aejsn282365a0a05e'
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
