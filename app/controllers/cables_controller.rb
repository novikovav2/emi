class CablesController < ApplicationController
  before_action :set_page_title
  before_action :set_cable, only: [:show, :edit, :update, :destroy]
  before_action :set_where_hash, only: [:index]
  before_action :set_limit_skip, only: [:index]
  before_action :set_order, only: [:index]

  # GET /cables
  # GET /cables.json
  def index
    @cables = Cable.new #без этого Rails не распознает тип Relation, которые получает дальше

    search = "(b1:Box)-[]-(p1:Patchpanel)-[]-(i1:Interface)-[r:PHYSICAL_CABLE]->
                (i2:Interface)-[]-(p2:Patchpanel)-[]-(b2:Box)"
    request = ActiveGraph::Base.new_query.match(search)

    @cables = request.where(@where_string).order(@sort_string).skip(@skip).limit(@limit).pluck(' r')

    @cables_count = request.count

    if @where_string.length > 1
      @filtered_count = ActiveGraph::Base.new_query
                                       .match(search)
                                       .where(@where_string)
                                       .pluck('r').count
    end
    # Находим все Box, из/в которые приходят кабели СКС
    # Это необходимо для фильтра
    @boxes = ActiveGraph::Base.new_query
                .match("(b:Box)-[]-(:Patchpanel)-[]-(:Interface)-[:PHYSICAL_CABLE]-(:Interface)")
                .pluck('distinct b')
    @materials = [{id: 0, name: :copper}, {id: 1, name: :optic}]

  end

  # GET /cables/1
  # GET /cables/1.json
  def show
  end

  # GET /cables/new
  def new
    @page_title << 'Новый кабель'

    @cable = Cable.new(from_node: Interface.new(),
                       to_node: Interface.new())
    @rooms = Room.all.order(:name)
    @interfaces = Interface.query_as(:i)
                      .match("(i)-[:INTERFACE_OF_PATCHPANEL]->(:Patchpanel)
                                    where not (i)-[:PHYSICAL_CABLE]-(:Interface)")
                      .pluck(:i)
  end

  # GET /cables/1/edit
  def edit
    @interfaces = Interface.query_as(:i)
                      .match("(i)-[:INTERFACE_OF_PATCHPANEL]->(:Patchpanel)")
                      .pluck(:i)
  end

  # POST /cables
  # POST /cables.json
  def create
    from_interface = Interface.find(cable_params['from_node'])
    to_interface = Interface.find(cable_params['to_node'])
    @cable = Cable.new(from_node: from_interface,
                       to_node: to_interface,
                       length: cable_params['length'])

    respond_to do |format|
      if @cable.save
        format.html { redirect_to @cable, notice: 'Cable was successfully created.' }
        format.json { render :show, status: :created, location: @cable }
      else
        format.html { redirect_to new_cable_url, alert: @cable.errors }
        format.json { render json: @cable.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /cables/1
  # PATCH/PUT /cables/1.json
  def update
    respond_to do |format|
      if @cable.update(length: cable_params['length'])
        format.html { redirect_to @cable, notice: 'Cable was successfully updated.' }
        format.json { render :show, status: :ok, location: @cable }
      else
        format.html { render :edit }
        format.json { render json: @cable.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cables/1
  # DELETE /cables/1.json
  def destroy
    @cable.destroy
    respond_to do |format|
      format.html { redirect_to cables_url, notice: 'Cable was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_cable
      @cable = Cable.find(params[:id])
      @page_title << @cable.from_node.patchpanel.box.name + '.' +
                      @cable.from_node.patchpanel.name + '.' +
                      @cable.from_node.name +
                      ' <-> ' +
                      @cable.to_node.patchpanel.box.name + '.' +
                      @cable.to_node.patchpanel.name + '.' +
                      @cable.to_node.name
    end

    # Only allow a list of trusted parameters through.
    def cable_params
      params.fetch(:cable, {}).permit(:from_node, :to_node, :length)
    end

    def set_page_title
      @page_title = ['СКС']
    end

  def set_where_hash
    @where_string = '(EXISTS (i1.uuid))'

    if params['from_box'] and params['from_box'].length() > 0
      @where_string += ' AND (b1.uuid = "' + params['from_box'] + '" OR b2.uuid = "' + params['from_box'] + '")'
      @from_box = Box.find(params['from_box'])
    end

    if params['from_patchpanel'] and params['from_patchpanel'].length() > 0
      @where_string += ' AND (p1.uuid = "' + params['from_patchpanel'] + '" OR p2.uuid = "' + params['from_patchpanel'] + '")'
      @from_patchpanel = Patchpanel.find(params['from_patchpanel'])
    end

    if params['from_interface'] and params['from_interface'].length() > 0
      @where_string += ' AND (i1.uuid = "' + params['from_interface'] + '" OR i2.uuid = "' + params['from_interface'] + '")'
      @from_interface = Interface.find(params['from_interface'])
    end

    if params['to_box'] and params['to_box'].length() > 0
      @where_string += ' AND (b2.uuid = "' + params['to_box'] + '")'
      @to_box = Box.find(params['to_box'])
    end

    if params['to_patchpanel'] and params['to_patchpanel'].length() > 0
      @where_string += ' AND (p2.uuid = "' + params['to_patchpanel'] + '")'
      @to_patchpanel = Patchpanel.find(params['to_patchpanel'])
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
    elsif @current_sort == 'from_patchpanel'
      @sort_string = 'p1.name'
    elsif @current_sort == 'from_interface'
      @sort_string = 'i1.name'
    elsif @current_sort == 'to_box'
        @sort_string = 'b2.name'
    elsif @current_sort == 'to_patchpanel'
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
