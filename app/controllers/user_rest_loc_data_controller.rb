class UserRestLocDataController < ApplicationController
  before_action :set_user_rest_loc_datum, only: %i[ show edit update destroy ]

  # GET /user_rest_loc_data or /user_rest_loc_data.json
  def index
    @user_rest_loc_data = UserRestLocDatum.all
  end

  # GET /user_rest_loc_data/1 or /user_rest_loc_data/1.json
  def show

  end

  # GET /user_rest_loc_data/new
  def new
    @user_rest_loc_datum = UserRestLocDatum.new
  end

  # GET /user_rest_loc_data/1/edit
  def edit
  end

  # POST /user_rest_loc_data or /user_rest_loc_data.json
  def create
    @user_rest_loc_datum = UserRestLocDatum.new(user_rest_loc_datum_params)

    respond_to do |format|
      if @user_rest_loc_datum.save
        format.html { redirect_to @user_rest_loc_datum, notice: "User rest loc datum was successfully created." }
        format.json { render :show, status: :created, location: @user_rest_loc_datum }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user_rest_loc_datum.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /user_rest_loc_data/1 or /user_rest_loc_data/1.json
  def update
    respond_to do |format|
      if @user_rest_loc_datum.update(user_rest_loc_datum_params)
        format.html { redirect_to @user_rest_loc_datum, notice: "User rest loc datum was successfully updated." }
        format.json { render :show, status: :ok, location: @user_rest_loc_datum }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user_rest_loc_datum.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /user_rest_loc_data/1 or /user_rest_loc_data/1.json
  def destroy
    @user_rest_loc_datum.destroy
    respond_to do |format|
      format.html { redirect_to user_rest_loc_data_url, notice: "User rest loc datum was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user_rest_loc_datum
      begin
        if params[:user_id] != nil
          if UserRestLocDatum.find(params[:user_id]) != nil
            @user_rest_loc_datum = UserRestLocDatum.where(user_id: params[:user_id])
            p "Finding user rest loc"
            p @user_rest_loc_datum
          end
        else
          redirect_to root_path, alert: "History not found"
        end
      rescue
        redirect_to root_path, alert: "History not found"
      end
    end

    # Only allow a list of trusted parameters through.
    def user_rest_loc_datum_params
      params.require(:user_rest_loc_datum).permit(:lsoa_name, :lad_name, :cluster_name, :lat, :long, :rest_cat, :score, :user)
    end
end
