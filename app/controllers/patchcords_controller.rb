class PatchcordsController < ApplicationController
  before_action :set_patchcord, only: [:show, :edit, :update, :destroy]

  # GET /patchcords
  # GET /patchcords.json
  def index
    @patchcords = Patchcord.all
  end

  # GET /patchcords/1
  # GET /patchcords/1.json
  def show
  end

  # GET /patchcords/new
  def new
    @patchcord = Patchcord.new(from_node: Interface.new,
                               to_node: Interface.new)
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
end
