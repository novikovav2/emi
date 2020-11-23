class LogicalLinksController < ApplicationController
  before_action :set_page_title
  before_action :set_logical_link, only: [:show, :destroy]

  # GET /logical_links
  # GET /logical_links.json
  def index
    @logical_links = LogicalLink.all
  end

  # GET /logical_links/1
  # GET /logical_links/1.json
  def show
    # Создаем массив соединений
    # Каждое соединение - хеш с полями: from, to, type, connected
    @relations = []
    if @logical_link.connected?
      relations_raw = ActiveGraph::Base.query(
          'match (start {uuid: $start_id})-
                   [r:PHYSICAL_PATCHCORD|PHYSICAL_CABLE *1..100]-
                   (end {uuid: $end_id}) RETURN r',
          start_id: @logical_link.from_node.id,
          end_id: @logical_link.to_node.id)
          .first.values[0]

      relation = {}
      relations_raw.each do |relation_raw|
        relation = {}
        case relation_raw.type
        when :PHYSICAL_PATCHCORD
          rel = Patchcord.find(relation_raw.id)
          relation["type"] = "patchcord"
        when :PHYSICAL_CABLE
          rel = Cable.find(relation_raw.id)
          relation["type"] = "sks"
        end

        relation["from"] = rel.from_node
        relation["to"] = rel.to_node
        relation["connected"] = true
        @relations << relation
      end


    else
      request = ActiveGraph::Base.query("MATCH (start:Interface {uuid: $start_id}),
                                         (end:Interface {uuid: $end_id})
                                         CALL gds.alpha.shortestPath.stream({
                                          nodeQuery: 'match (n) return id(n) as id',
                                          relationshipQuery: 'match (n)-[r]-(m) return id(n) as source, id(m) as target, r.length as weight',
                                          startNode: start,
                                          endNode: end,
                                          relationshipWeightProperty: 'weight'
                                        })
                                        YIELD nodeId, cost
                                        RETURN gds.util.asNode(nodeId) AS name, cost",
                                        start_id: @logical_link.from_node.id,
                                        end_id: @logical_link.to_node.id)
      nodes = []
      loop do
        begin
          node_raw = request.next.values[0]
          case node_raw.labels[0]
            when :Interface
              node = Interface.where(neo_id: node_raw.id).first
            # when :Device
            #   node = Device.where(neo_id: node_raw.id).first
            # when :Box
            #   node = box.where(neo_id: node_raw.id).first
            # when :Room
            #   node = Room.where(neo_id: node_raw.id).first
            # when :Building
            #   node = Building.where(neo_id: node_raw.id).first
          end
          nodes << node
        rescue
          break
        end
      end

      relation = {}
      nodes.each do |node|
        if relation["from"].nil?
          relation["from"] = node
        else
          relation["to"] = node
          if relation["from"].patchcorded_to == relation["to"]   # Если интефейсы уже физически подключены патчкордом
            relation["type"] = "patchcord"
            relation["connected"] = true
          elsif  relation["from"].sks_to == relation["to"]   # Если интефейсы уже физически подключены СКС
            relation["type"] = "sks"
            relation["connected"] = true
          else
            relation["type"] = "new_patchcord"
            relation["connected"] = false
          end
        end

        if relation["from"] and relation["to"]
          @relations << relation
          relation = {}
          relation["from"] = node
        end

      end

    end

  end

  # GET /logical_links/new
  def new
    @page_title << 'Новая логическая связь'
    @logical_link = LogicalLink.new(from_node: Interface.new(),
                                    to_node: Interface.new())
    @interfaces = Interface.query_as(:i).match("(i)-[:INTERFACE_OF_DEVICE]->(:Device)").pluck(:i)
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

    def set_page_title
      @page_title = ['Логические связи']
    end
end
