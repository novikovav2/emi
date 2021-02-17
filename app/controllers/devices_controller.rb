class DevicesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_page_title
  before_action :set_device, only: [:show, :edit, :update, :destroy]
  before_action :set_where_string, only: [:index]
  before_action :set_limit_skip, only: [:index]
  before_action :set_order, only: [:index]
  after_action :clear_cache, only: [:create, :update, :destroy]

  # GET /devices
  # GET /devices.json
  def index
    search = "(n:Device)-[]-(b:Box)
              optional match (i1:Interface {material: $copper})-[]->(n)
              optional match (i2:Interface {material: $optic})-[]->(n)"
    request = ActiveGraph::Base.new_query.match(search).params(copper: 0, optic: 1)

    @devices = Device.new
    @devices = request.where(@where_string)
                      .order(@sort_string)
                      .skip(@skip)
                      .limit(@limit)
                      .pluck('n, b, count(i1), count(i2)')
                       .collect do |result| {
                          self: result[0],
                          box: result[1],
                          copper_count: result[2],
                          optic_count: result[3]
                        }
                        end

    @devices_count = request.count('n')

    # Для фильтрации
    @materials = [{id: 0, name: :copper}, {id: 1, name: :optic}]
    @devices_list = request.order('n.name').pluck('distinct n')
    @boxes = request.order('b.name').pluck('distinct b')
  end

  # GET /devices/1
  # GET /devices/1.json
  def show
    search = "(d {uuid: $uuid})<-[:INTERFACE_OF_DEVICE]-(i:Interface)
              OPTIONAL MATCH (i)-[p:PHYSICAL_PATCHCORD]-(i1:Interface)--(d1)--(b1:Box)
              OPTIONAL MATCH (i)-[l:LOGICAL_LINK]-(i2:Interface)--(d2:Device)--(b2:Box)
              OPTIONAL MATCH (i)-[:PHYSICAL_PATCHCORD|PHYSICAL_CABLE *1..100]-(i3:Interface)--(d3)--(b3:Box)"

    @interfaces = @device.query_as(:d)
                         .match(search)
                         .params(uuid: @device.id)
                         .order_by('i.name')
                         .pluck('i, i1, d1, b1, i2, d2, b2,
                                last(collect(i3)), last(collect(d3)), last(collect(b3)), p, l')
                          .collect do |result| {
                            self: result[0],
                            patchcorded_to_int: result[1],
                            patchcorded_to_device: result[2],
                            patchcorded_to_box: result[3],
                            logical_linked_to_int: result[4],
                            logical_linked_to_device: result[5],
                            logical_linked_to_box: result[6],
                            connected_to_int: result[7],
                            connected_to_device: result[8],
                            connected_to_box: result[9],
                            patchcord: result[10],
                            logical_link: result[11]
                          }
                          end
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
    if @device.destroy
      flash[:notice] = 'Device was successfully destroyed.'
      redirect_to devices_path
    else
      flash[:alert] = @device.errors.messages[:base][0]
      redirect_back(fallback_location: device_path(@device))
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
    end

    if params['box'] and params['box'].length() > 0
      @where_string += ' AND (b.uuid = "' + params['box']  + '")'
    end

  end

    def set_limit_skip
      @limit = 20
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

  def clear_cache
    Rails.cache.delete_matched('/devices*')
    Rails.cache.delete_matched('/patchcords/data*')
    if params[:id]
      Rails.cache.delete(params[:id])
    end
  end
end
