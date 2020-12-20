class BoxesController < ApplicationController
  before_action :set_page_title
  before_action :set_box, only: [:show, :edit, :update, :destroy]
  before_action :set_limit_skip, only: [:index, :show]
  before_action :set_order, only: [:index]

  # GET /boxes
  # GET /boxes.json
  def index
    @boxes_count = Box.all.count

    search = "(b:Box)-[]->(r:Room)"
    request = ActiveGraph::Base.new_query.match(search).order(@sort_string).skip(@skip).limit(@limit)

    @boxes = request.pluck('b')
  end

  # GET /boxes/1
  # GET /boxes/1.json
  def show

  end

  # GET /boxes/new
  def new
    @page_title << 'Новый монтажный шкаф'
    @box = Box.new
  end

  # GET /boxes/1/edit
  def edit
  end

  # POST /boxes
  # POST /boxes.json
  def create
    @box = Box.new(box_params)

    respond_to do |format|
      if @box.save
        format.html { redirect_to @box, notice: 'Box was successfully created.' }
        format.json { render :show, status: :created, location: @box }
      else
        format.html { render :new }
        format.json { render json: @box.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /boxes/1
  # PATCH/PUT /boxes/1.json
  def update
    respond_to do |format|
      if @box.update(box_params)
        format.html { redirect_to @box, notice: 'Box was successfully updated.' }
        format.json { render :show, status: :ok, location: @box }
      else
        format.html { render :edit }
        format.json { render json: @box.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /boxes/1
  # DELETE /boxes/1.json
  def destroy
    @box.destroy
    respond_to do |format|
      format.html { redirect_to boxes_url, notice: 'Box was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_box
      @box = Box.find(params[:id])
      @page_title << @box.name
    end

    # Only allow a list of trusted parameters through.
    def box_params
      params.fetch(:box, {}).permit(:name, :room)
    end

    def set_page_title
      @page_title = ['Монтажные шкафы']
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
      @sort_string = 'b.name'
    elsif @current_sort == 'room'
      @sort_string = 'r.name'
    end

    if @current_order == 1
      @sort_string += ' desc'
    end
  end
end
