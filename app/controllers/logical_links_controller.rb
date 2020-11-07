class LogicalLinksController < ApplicationController
  before_action :set_logical_link, only: [:show, :destroy]

  # GET /logical_links
  # GET /logical_links.json
  def index
    @logical_links = LogicalLink.all
  end

  # GET /logical_links/1
  # GET /logical_links/1.json
  def show
  end

  # GET /logical_links/new
  def new
    @logical_link = LogicalLink.new(from_node: Interface.new(),
                                    to_node: Interface.new())
  end


  # POST /logical_links
  # POST /logical_links.json
  def create
    from_interface = Interface.find(logical_link_params['from_node'])
    to_interface = Interface.find(logical_link_params['to_node'])
    @logical_link = LogicalLink.new(from_node: from_interface,
                                    to_node: to_interface)

    respond_to do |format|
      if @logical_link.save
        format.html { redirect_to @logical_link, notice: 'Logical link was successfully created.' }
        format.json { render :show, status: :created, location: @logical_link }
      else
        format.html { render :new }
        format.json { render json: @logical_link.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /logical_links/1
  # DELETE /logical_links/1.json
  def destroy
    @logical_link.destroy
    respond_to do |format|
      format.html { redirect_to logical_links_url, notice: 'Logical link was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_logical_link
      @logical_link = LogicalLink.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def logical_link_params
      params.fetch(:logical_link, {}).permit(:from_node, :to_node)
    end
end
