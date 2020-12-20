class RoomsController < ApplicationController
  before_action :set_page_title
  before_action :set_room, only: [:show, :edit, :update, :destroy]
  before_action :set_limit_skip, only: [:index, :show]
  before_action :set_order, only: [:index]

  # GET /rooms
  # GET /rooms.json
  def index
    @rooms_count = Room.all.count

    search = "(r:Room)-[]->(b:Building)"
    request = ActiveGraph::Base.new_query.match(search).order(@sort_string).skip(@skip).limit(@limit)

    @rooms = request.pluck('r')
  end

  # GET /rooms/1
  # GET /rooms/1.json
  def show
    @boxes_count = @room.boxes.count
    @boxes = @room.boxes.order(:name).skip(@skip).limit(@limit)
  end

  # GET /rooms/new
  def new
    @page_title << 'Новое помещение'
    @room = Room.new
  end

  # GET /rooms/1/edit
  def edit
  end

  # POST /rooms
  # POST /rooms.json
  def create
    @room = Room.new(room_params)

    respond_to do |format|
      if @room.save
        format.html { redirect_to @room, notice: 'Помещение успешно добавлено' }
        format.json { render :show, status: :created, location: @room }
      else
        format.html { render :new, alert: 'Что-то пошло не так' }
        format.json { render json: @room.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /rooms/1
  # PATCH/PUT /rooms/1.json
  def update
    respond_to do |format|
      if @room.update(room_params)
        format.html { redirect_to @room, notice: 'Room was successfully updated.' }
        format.json { render :show, status: :ok, location: @room }
      else
        format.html { render :edit, alert: 'Что-то пошло не так' }
        format.json { render json: @room.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /rooms/1
  # DELETE /rooms/1.json
  def destroy
    @room.destroy
    respond_to do |format|
      format.html { redirect_to rooms_url, notice: 'Помещение успешно удалено' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_room
      @room = Room.find(params[:id])
      @page_title << @room.name
    end

    # Only allow a list of trusted parameters through.
    def room_params
      params.fetch(:room, {}).permit(:name, :floor, :building)
    end

    def set_page_title
      @page_title = ['Помещения']
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
      @sort_string = 'r.name'
    elsif @current_sort == 'building'
      @sort_string = 'b.name'
    end

    if @current_order == 1
      @sort_string += ' desc'
    end
  end

end
