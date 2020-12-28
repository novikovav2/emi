class PatchcordsController < ApplicationController
  before_action :set_page_title
  before_action :set_patchcord, only: [:show, :edit, :update, :destroy]
  before_action :set_limit_skip, only: [:index]
  before_action :set_order, only: [:index]

  # GET /patchcords
  # GET /patchcords.json
  def index
    @patchcords = Patchcord.new

    search = "(b1:Box)-[]-(p1)-[]-(i1:Interface)-[r:PHYSICAL_PATCHCORD]->
                (i2:Interface)-[]-(p2)-[]-(b2:Box)"
    request = ActiveGraph::Base.new_query.match(search).order(@sort_string).skip(@skip).limit(@limit)

    @patchcords = request.pluck('r')

    @patchcords_count = ActiveGraph::Base.new_query
                                     .match("(:Box)-[]-()-[]-(:Interface)-[r:PHYSICAL_PATCHCORD]->(:Interface)")
                                     .pluck('r').count

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
