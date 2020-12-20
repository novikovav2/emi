class BuildingsController < ApplicationController
  before_action :set_page_title
  before_action :set_building, only: [:show, :edit, :update, :destroy]
  before_action :set_limit_skip, only: [:show]


  # GET /buildings
  # GET /buildings.json
  def index

    @buildings = Building.all
  end

  # GET /buildings/1
  # GET /buildings/1.json
  def show
    @rooms_count = @building.rooms.count
    @rooms = @building.rooms.order(:name).skip(@skip).limit(@limit)
  end

  # GET /buildings/new
  def new
    @page_title << 'Новое здание'
    @building = Building.new
  end

  # GET /buildings/1/edit
  def edit
    @page_title << 'Изменить'
  end

  # POST /buildings
  # POST /buildings.json
  def create
    @building = Building.new(building_params)

    respond_to do |format|
      if @building.save
        format.html { redirect_to @building, notice: 'Building was successfully created.' }
        format.json { render :show, status: :created, location: @building }
      else
        format.html { render :new }
        format.json { render json: @building.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /buildings/1
  # PATCH/PUT /buildings/1.json
  def update
    respond_to do |format|
      if @building.update(building_params)
        format.html { redirect_to @building, notice: 'Building was successfully updated.' }
        format.json { render :show, status: :ok, location: @building }
      else
        format.html { render :edit }
        format.json { render json: @building.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /buildings/1
  # DELETE /buildings/1.json
  def destroy
    @building.destroy
    respond_to do |format|
      format.html { redirect_to buildings_url, notice: 'Building was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_building
      @building = Building.find(params[:id])
      @page_title << @building.name
    end

    # Only allow a list of trusted parameters through.
    def building_params
      params.fetch(:building, {}).permit(:name, :address)
    end

    def set_page_title
      @page_title = ['Здания']
    end

  def set_limit_skip
    @limit = 10
    @page = params['page'] ?  params['page'].to_i : 1
    @skip = @limit * ( @page - 1 )
  end
end
