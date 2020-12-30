class DevicesController < ApplicationController
  before_action :set_page_title
  before_action :set_device, only: [:show, :edit, :update, :destroy]
  before_action :set_where_string, only: [:index]
  before_action :set_limit_skip, only: [:index]
  before_action :set_order, only: [:index]

  # GET /devices
  # GET /devices.json
  def index
    search = "(n:Device)-[]-(b:Box)"
    request = ActiveGraph::Base.new_query.match(search)

    @devices = Device.new
    @devices = request.where(@where_string).order(@sort_string).skip(@skip).limit(@limit).pluck('n')

    @devices_count = request.count('n')

    # Для фильтрации
    @materials = [{id: 0, name: :copper}, {id: 1, name: :optic}]
    @devices_list = request.pluck('distinct n')
    @boxes = request.pluck('distinct b')
  end

  # GET /devices/1
  # GET /devices/1.json
  def show
  end

  # GET /devices/new
  def new
    @page_title << 'Новое оборудование'
    @device = Device.new
  end

  # GET /devices/1/edit
  def edit
  end

  # POST /devices
  # POST /devices.json
  def create
    @device = Device.new(device_params)

    respond_to do |format|
      if @device.save
        format.html { redirect_to @device, notice: 'Device was successfully created.' }
        format.json { render :show, status: :created, location: @device }
      else
        format.html { render :new }
        format.json { render json: @device.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /devices/1
  # PATCH/PUT /devices/1.json
  def update
    respond_to do |format|
      if @device.update(device_params)
        format.html { redirect_to @device, notice: 'Device was successfully updated.' }
        format.json { render :show, status: :ok, location: @device }
      else
        format.html { render :edit }
        format.json { render json: @device.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /devices/1
  # DELETE /devices/1.json
  def destroy
    @device.interfaces.destroy_all
    @device.destroy
    respond_to do |format|
      format.html { redirect_to devices_url, notice: 'Device was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_device
      @device = Device.find(params[:id])
      @page_title << @device.name
    end

    # Only allow a list of trusted parameters through.
    def device_params
      params.fetch(:device, {}).permit(:name, :box)
    end

    def set_page_title
      @page_title = ['Оборудование']
    end

  def set_where_string
    @where_string = '(EXISTS (n.uuid))'

    if params['device'] and params['device'].length() > 0
      @where_string += 'AND (n.uuid = "' + params['device'] + '")'
      # @from_device = Device.find(params['from_device'])
    end

    if params['box'] and params['box'].length() > 0
      @where_string += ' AND (b.uuid = "' + params['box']  + '")'
      # @from_interface = Interface.find(params['from_interface'])
    end

  end

    def set_limit_skip
      @limit = 10
      @page = params['page'] ?  params['page'].to_i : 1
      @skip = @limit * ( @page - 1 )
    end

  def set_order
    @current_order = params[:order].to_i || 0
    @current_sort = params[:sort] || 'name'

    if @current_sort == 'box'
      @sort_string = "b.name"
    else
      @sort_string = "n.name"
    end

    if @current_order == 1
      @sort_string += ' desc'
    end
  end
end
