class DistrictDataController < ApplicationController
  require 'csv'
  before_action :set_district_datum, only: %i[ show edit update destroy ]

  # GET /district_data or /district_data.json
  def index
    @district_data = DistrictDatum.all
  end

  # GET /district_data/1 or /district_data/1.json
  def show
  end

  # GET /district_data/new
  def new
    @district_datum = DistrictDatum.new
  end


  # GET /district_data/1/edit
  def edit
  end

  # POST /district_data or /district_data.json
  def create
    @district_datum = DistrictDatum.new(district_datum_params)

    respond_to do |format|
      if @district_datum.save
        format.html { redirect_to @district_datum, notice: "District datum was successfully created." }
        format.json { render :show, status: :created, location: @district_datum }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @district_datum.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /district_data/1 or /district_data/1.json
  def update
    respond_to do |format|
      if @district_datum.update(district_datum_params)
        format.html { redirect_to @district_datum, notice: "District datum was successfully updated." }
        format.json { render :show, status: :ok, location: @district_datum }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @district_datum.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /district_data/1 or /district_data/1.json
  def destroy
    @district_datum.destroy
    respond_to do |format|
      format.html { redirect_to district_data_url, notice: "District datum was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_district_datum
      @district_datum = DistrictDatum.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def district_datum_params
      params.require(:district_datum).permit(:name, :restaurant_type, :restaurant_type_num, :restaurants_avg_rating, :float, :population, :restaurants_sum_rating, :restaurants_price_avg_lvl, :public_trans_lvl, :direct_competitors, :indirect_competitors, :purchasing_power, :restaurant_price_index, :rent_index)
    end
end
