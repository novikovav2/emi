class BoxesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_page_title
  before_action :set_box, only: [:show, :edit, :update, :destroy]
  before_action :set_where_string, only: [:index]
  before_action :set_limit_skip, only: [:index, :show]
  before_action :set_order, only: [:index]
  after_action :clear_cache, only: [:create, :update, :destroy]

  # GET /boxes
  # GET /boxes.json
  def index
    @boxes_count = Rails.cache.fetch('/boxescount') do
                      Box.all.count
                    end

    search = "(b:Box)-[]->(r:Room)"
    request = ActiveGraph::Base.new_query.match(search)

    @boxes = Rails.cache.fetch("/boxes/data/#{@where_string}/#{@sort_string}/#{@skip}/#{@limit}") do
                  request.where(@where_string)
                         .order(@sort_string)
                         .skip(@skip)
                         .limit(@limit)
                         .pluck('b')
                end




    # Для фильтрации
    @boxes_list = Rails.cache.fetch('/boxes/boxes_list') do
                    request.order('b.name').pluck('distinct b')
                  end
    @rooms = Rails.cache.fetch('/boxes/rooms') do
              request.order('r.name').pluck('distinct r')
            end
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
    if @box.destroy
      flash[:notice] = 'Box was successfully destroyed.'
      redirect_to boxes_path
    else
      flash[:alert] = @box.errors.messages[:base][0]
      redirect_back(fallback_location: box_path(@box))
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_box
      @box = Rails.cache.fetch(params[:id]) do
        Box.find(params[:id])
      end
      @page_title << @box.name
    end

    # Only allow a list of trusted parameters through.
    def box_params
      params.fetch(:box, {}).permit(:name, :room)
    end

    def set_page_title
      @page_title = ['Монтажные шкафы']
    end

  def set_where_string
    @where_string = '(EXISTS (b.uuid))'

    if params['room'] and params['room'].length() > 0
      @where_string += 'AND (r.uuid = "' + params['room'] + '")'
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

    if @current_sort == 'name'
      @sort_string = 'b.name'
    elsif @current_sort == 'room'
      @sort_string = 'r.name'
    end

    if @current_order == 1
      @sort_string += ' desc'
    end
  end

  def clear_cache
    Rails.cache.delete_matched('/boxes*')
    if params[:id]
      Rails.cache.delete(params[:id])
    end
  end
end

