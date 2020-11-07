class InterfacesController < ApplicationController
  before_action :set_interface, only: [:show, :edit, :update, :destroy]
  before_action :set_device

  # GET /interfaces
  # GET /interfaces.json
  # def index
  #   @interfaces = Interface.all
  # end

  # GET /interfaces/1
  # GET /interfaces/1.json
  def show
  end

  # GET /interfaces/new
  def new
    @interface = Interface.new
  end

  # GET /interfaces/1/edit
  def edit
  end

  # POST /interfaces
  # POST /interfaces.json
  def create
    @interface = Interface.new(interface_params)
    @interface.device = @device

    respond_to do |format|
      if @interface.save
        format.html { redirect_to device_path(@device), notice: 'Interface was successfully created.' }
        format.json { render :show, status: :created, location: @interface }
      else
        format.html { redirect_to device_path(@device), notice: 'Proccesed with errors.' }
        format.json { render json: @interface.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /interfaces/1
  # PATCH/PUT /interfaces/1.json
  def update
    respond_to do |format|
      if @interface.update(interface_params)
        format.html { redirect_to device_path(@device), notice: 'Interface was successfully updated.' }
        format.json { render :show, status: :ok, location: @interface }
      else
        format.html { render :edit }
        format.json { render json: @interface.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /interfaces/1
  # DELETE /interfaces/1.json
  def destroy
    @interface.destroy
    respond_to do |format|
      format.html { redirect_to device_path(@device), notice: 'Interface was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_interface
      @interface = Interface.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def interface_params
      params.fetch(:interface, {}).permit(:name, :device_id, :material)
    end

  def set_device
    @device = Device.find(params[:device_id])
  end
end
