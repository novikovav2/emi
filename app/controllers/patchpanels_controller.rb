class PatchpanelsController < ApplicationController
  before_action :set_page_title
  before_action :set_patchpanel, only: [:show, :edit, :update, :destroy]

  # GET /patchpanels
  # GET /patchpanels.json
  def index
    @patchpanels = Patchpanel.all.order(:name)
  end

  # GET /patchpanels/1
  # GET /patchpanels/1.json
  def show
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
end
