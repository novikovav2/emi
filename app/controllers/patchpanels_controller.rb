class PatchpanelsController < ApplicationController
  before_action :set_page_title
  before_action :set_patchpanel, only: [:show, :edit, :update, :destroy]
  before_action :set_limit_skip, only: [:index, :show]
  before_action :set_order, only: [:index]

  # GET /patchpanels
  # GET /patchpanels.json
  def index
    if params['box_id'] # Используется в форме фильтрации
      @patchpanels = Box.find(params['box_id']).patchpanels
    else
      @patchpanels_count = Patchpanel.all.count

      search = "(p:Patchpanel)-[]->(b:Box)"
      request = ActiveGraph::Base.new_query.match(search).order(@sort_string).skip(@skip).limit(@limit)

      @patchpanels = request.pluck('p')
    end

  end

  # GET /patchpanels/1
  # GET /patchpanels/1.json
  def show
    all_interfaces = @patchpanel.interfaces.order(:name)
    @interfaces_count = all_interfaces.count
    @interfaces = all_interfaces.skip(@skip).limit(@limit)

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

  def set_limit_skip
    @limit = 10
    @page = params['page'] ?  params['page'].to_i : 1
    @skip = @limit * ( @page - 1 )
  end

  def set_order
    @current_order = params[:order].to_i || 0
    @current_sort = params[:sort] || 'name'

    if @current_sort == 'name'
      @sort_string = 'p.name'
    elsif @current_sort == 'box'
      @sort_string = 'b.name'
    end

    if @current_order == 1
      @sort_string += ' desc'
    end
  end
end
