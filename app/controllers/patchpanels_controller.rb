class PatchpanelsController < ApplicationController
  before_action :set_page_title
  before_action :set_patchpanel, only: [:show, :edit, :update, :destroy]
  before_action :set_limit_skip, only: [:index, :show]
  before_action :set_where_string, only: [:index]
  before_action :set_order_for_index, only: [:index]
  before_action :set_order_for_show, only: [:show]
  before_action :change_sort_order, only: [:index, :show]

  # GET /patchpanels
  # GET /patchpanels.json
  def index
      search = "(p:Patchpanel)-[]->(b:Box)"
      request = ActiveGraph::Base.new_query.match(search)

      @patchpanels = request.where(@where_string).order(@sort_string).skip(@skip).limit(@limit).pluck('p')
      @patchpanels_count = request.count
      @patchpaneles_list = request.pluck('distinct p')
      @boxes = request.pluck('distinct b')
  end

  # GET /patchpanels/1
  # GET /patchpanels/1.json
  def show
    search = "(p:Patchpanel)<-[:`INTERFACE_OF_PATCHPANEL`]-(i:Interface)"
    query = ActiveGraph::Base.new_query.match(search).where('p.uuid = ' + '"' + @patchpanel.id + '"')
    @interfaces_count = query.count
    @interfaces = query.order(@sort_string).skip(@skip).limit(@limit).pluck(:i)
  end

  # GET /patchpanels/new
  def new
    @page_title << 'Новая патчпанель'
    @patchpanel = Patchpanel.new
  end

  # GET /patchpanels/1/edit
  def edit

  end

  # POST /patchpanels
  # POST /patchpanels.json
  def create
    @patchpanel = Patchpanel.new(patchpanel_params)

    respond_to do |format|
      if @patchpanel.save
        format.html { redirect_to @patchpanel, notice: 'Patchpanel was successfully created.' }
        format.json { render :show, status: :created, location: @patchpanel }
      else
        format.html { render :new }
        format.json { render json: @patchpanel.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /patchpanels/1
  # PATCH/PUT /patchpanels/1.json
  def update
    respond_to do |format|
      if @patchpanel.update(patchpanel_params)
        format.html { redirect_to @patchpanel, notice: 'Patchpanel was successfully updated.' }
        format.json { render :show, status: :ok, location: @patchpanel }
      else
        format.html { render :edit }
        format.json { render json: @patchpanel.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /patchpanels/1
  # DELETE /patchpanels/1.json
  def destroy
    @patchpanel.interfaces.destroy_all
    @patchpanel.destroy
    respond_to do |format|
      format.html { redirect_to patchpanels_url, notice: 'Patchpanel was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_patchpanel
      @patchpanel = Patchpanel.find(params[:id])
      @page_title << @patchpanel.name
    end

    # Only allow a list of trusted parameters through.
    def patchpanel_params
      params.fetch(:patchpanel, {}).permit(:name, :box, :material)
    end

    def set_page_title
      @page_title = ['Патчпанели']
    end

  def set_where_string
    @where_string = '(EXISTS (b.uuid))'

    if params['patchpanel'] and params['patchpanel'].length() > 0
      @where_string += 'AND (p.uuid = "' + params['patchpanel'] + '")'
    end

    if params['box'] and params['box'].length() > 0
      @where_string += ' AND (b.uuid = "' + params['box']  + '")'
    end
  end

  def set_limit_skip
    @limit = 10
    @page = params['page'] ?  params['page'].to_i : 1
    @skip = @limit * ( @page - 1 )
  end

  def set_order_for_index
    @current_order = params[:order].to_i || 0
    @current_sort = params[:sort] || 'name'

    if @current_sort == 'name'
      @sort_string = 'p.name'
    elsif @current_sort == 'box'
      @sort_string = 'b.name'
    end
  end

  def set_order_for_show
    @current_order = params[:order].to_i || 0
    @current_sort = params[:sort] || 'name'

    if @current_sort == 'name'
      @sort_string = 'i.name'
    elsif @current_sort == 'connected'
      @sort_string = 'i.connected'
    end
  end

  def change_sort_order
    if @current_order == 1
      @sort_string += ' desc'
    end
  end
end
