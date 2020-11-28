class InterfacesController < ApplicationController
  before_action :set_page_title
  before_action :set_interface, only: [:show, :edit, :update, :destroy]
  before_action :set_owner

  # GET /interfaces
  # GET /interfaces.json
  def index
    if @device
      @interfaces = @device.interfaces
    else
      @interfaces = @patchpanel.interfaces
    end
  end

  # GET /interfaces/1
  # GET /interfaces/1.json
  def show
  end

  # GET /interfaces/new
  def new
    @page_title << 'Новый интерфейс'
    @interface = Interface.new
    if @patchpanel
      @interface.material = @patchpanel.material
    end
  end

  # GET /interfaces/1/edit
  def edit
  end

  # POST /interfaces
  # POST /interfaces.json
  def create
    @interface = Interface.new(interface_params)
    if @device
      @interface.device = @device
    else
      @interface.patchpanel = @patchpanel
      @interface.update(material: @patchpanel.material)
    end


    respond_to do |format|
      if @interface.save
        format.html {
          if @device
            redirect_to device_path(@device), notice: 'Interface was successfully created.'
          else
            redirect_to patchpanel_path(@patchpanel), notice: 'Interface was successfully created.'
          end
        }
        format.json { render :show, status: :created, location: @interface }
      else
        format.html {
          if @device
            redirect_to device_path(@device), notice: 'Proccesed with errors.'
          else
            redirect_to patchpanel_path(@patchpanel), notice: 'Proccesed with errors.'
          end
        }
        format.json { render json: @interface.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /interfaces/1
  # PATCH/PUT /interfaces/1.json
  def update
    respond_to do |format|
      if @interface.update(interface_params)
        format.html {
          if @device
            redirect_to device_path(@device), notice: 'Interface was successfully updated.'
          else
            redirect_to patchpanel_path(@patchpanel), notice: 'Interface was successfully updated.'
          end
        }
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
    flash[:notice] = 'Interface was successfully destroyed.'
    respond_to do |format|
      format.html {
        @device ? redirect_back(fallback_location: device_path(@device)) :
            redirect_back(fallback_location: patchpanel_path(@patchpanel))
      }
      format.json { head :no_content }
    end
  end

  def generate
    if generate_params.to_i
      (1..generate_params.to_i).each do |i|
        int = Interface.create(name: i, material: @patchpanel.material)
        @patchpanel.interfaces << int
      end
      redirect_to patchpanel_path(@patchpanel), notice: 'Interface was successfully generated.'
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

  def generate_params
    params.fetch(:number)
  end

  def set_owner
    if params[:device_id]
      @device = Device.find(params[:device_id])
      @page_title << @device.name
    else
      @patchpanel = Patchpanel.find(params[:patchpanel_id])
      @page_title << @patchpanel.name
    end

  end

  def set_page_title
    @page_title = ['Оборудование']
    if params[:device_id]
      @page_title = ['Оборудование']
    else
      @page_title = ['Патчпанели']
    end
  end
end
