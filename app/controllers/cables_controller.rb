class CablesController < ApplicationController
  before_action :set_page_title
  before_action :set_cable, only: [:show, :edit, :update, :destroy]

  # GET /cables
  # GET /cables.json
  def index
    @cables = Cable.all
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
        format.html { render :new }
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
end
