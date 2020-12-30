class PatchcordsController < ApplicationController
  before_action :set_page_title
  before_action :set_patchcord, only: [:show, :destroy]
  before_action :set_where_string, only: [:index]
  before_action :set_limit_skip, only: [:index]
  before_action :set_order, only: [:index]

  # GET /patchcords
  # GET /patchcords.json
  def index
    @patchcords = Patchcord.new

    search = "(b1:Box)-[]-(p1)-[]-(i1:Interface)-[r:PHYSICAL_PATCHCORD]->
                (i2:Interface)-[]-(p2)-[]-(b2:Box)"
    request = ActiveGraph::Base.new_query.match(search)

    @patchcords = request.where(@where_string).order(@sort_string).skip(@skip).limit(@limit)
                    .pluck('r')

    @patchcords_count = request.count

    if @where_string.length > 1
      @filtered_count = request.where(@where_string).count
    end

    # Находим все Box, из/в которые приходят кабели СКС
    # Это необходимо для фильтра
    @boxes = ActiveGraph::Base.new_query
                              .match("(b:Box)<-[]-()<-[]-(:Interface)-[:PHYSICAL_PATCHCORD]->(:Interface)")
                              .pluck('distinct b')
    @materials = [{id: 0, name: :copper}, {id: 1, name: :optic}]

  end

  # GET /patchcords/1
  # GET /patchcords/1.json
  def show
  end

  # GET /patchcords/new
  def new
    @page_title << 'Новый патчкорд'
    @patchcord = Patchcord.new(from_node: Interface.new,
                               to_node: Interface.new)
    @interfaces = Interface.where(connected: false)
  end

  # POST /patchcords
  # POST /patchcords.json
  def create
    from_interface = Interface.find(patchcord_params['from_node'])
    to_interface = Interface.find(patchcord_params['to_node'])
    @patchcord = Patchcord.new(from_node: from_interface,
                               to_node: to_interface)

    respond_to do |format|
      if @patchcord.save
        format.html { redirect_to @patchcord, notice: 'Patchcord was successfully created.' }
        format.json { render :show, status: :created, location: @patchcord }
      else
        format.html { render :new }
        format.json { render json: @patchcord.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /patchcords/1
  # DELETE /patchcords/1.json
  def destroy
    @patchcord.destroy
    respond_to do |format|
      format.html { redirect_to patchcords_url, notice: 'Patchcord was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_patchcord
      @patchcord = Patchcord.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def patchcord_params
      params.fetch(:patchcord, {}).permit(:from_node, :to_node)
    end

    def set_page_title
      @page_title = ['Патчкорды']
    end

  def set_where_string
    @where_string = '(EXISTS (i1.uuid))'

    if params['from_box'] and params['from_box'].length() > 0
      @where_string += ' AND (b1.uuid = "' + params['from_box'] + '" OR b2.uuid = "' + params['from_box'] + '")'
      @from_box = Box.find(params['from_box'])
    end

    if params['from_owner'] and params['from_owner'].length() > 0
      @where_string += ' AND (p1.uuid = "' + params['from_owner'] + '" OR p2.uuid = "' + params['from_owner'] + '")'
      begin
        @from_owner = Patchpanel.find(params['from_owner'])
      rescue
        @from_owner = Device.find(params['from_owner'])
      end
    end

    if params['from_interface'] and params['from_interface'].length() > 0
      @where_string += ' AND (i1.uuid = "' + params['from_interface'] + '" OR i2.uuid = "' + params['from_interface'] + '")'
      @from_interface = Interface.find(params['from_interface'])
    end

    if params['to_box'] and params['to_box'].length() > 0
      @where_string += ' AND (b2.uuid = "' + params['to_box'] + '")'
      @to_box = Box.find(params['to_box'])
    end

    if params['to_owner'] and params['to_owner'].length() > 0
      @where_string += ' AND (p2.uuid = "' + params['to_owner'] + '")'
      begin
        @to_owner = Patchpanel.find(params['to_owner'])
      rescue
        @to_owner = Device.find(params['to_owner'])
      end
    end

    if params['to_interface'] and params['to_interface'].length() > 0
      @where_string += ' AND (i2.uuid = "' + params['to_interface'] + '")'
      @to_interface = Interface.find(params['to_interface'])
    end

    if params['material'] and params['material'].length() > 0
      @where_string += " AND (r.material = #{params["material"]})"
      @material = params['material']
    end
  end

  def set_limit_skip
    @limit = 20
    @page = params['page'] ?  params['page'].to_i : 1
    @skip = @limit * ( @page - 1 )
  end

  def set_order
    @current_order = params[:order].to_i || 0
    @current_sort = params[:sort] || 'from_box'

    if @current_sort == 'from_box'
      @sort_string = 'b1.name'
    elsif @current_sort == 'from_owner'
      @sort_string = 'p1.name'
    elsif @current_sort == 'from_interface'
      @sort_string = 'i1.name'
    elsif @current_sort == 'to_box'
      @sort_string = 'b2.name'
    elsif @current_sort == 'to_owner'
      @sort_string = 'p2.name'
    elsif @current_sort == 'to_interface'
      @sort_string = 'i2.name'
    elsif @current_sort == 'material'
      @sort_string = 'r.material'
    end

    if @current_order == 1
      @sort_string += ' desc'
    end
  end
end
