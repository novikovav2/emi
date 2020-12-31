class MiscController < ApplicationController

  # Получаем список оборудования или патчпанелей в стойке
  # GET '/box_children/:id'
  def box_children
    search = "(b:Box)<-[]-(n)"
    query = ActiveGraph::Base.new_query.match(search).where('b.uuid="' +params[:id] + '"').order('n.name')
    @children = query.pluck(:n)
  end

  # Получаем список интерфейсов в оборудовании или в патчпанели
  # GET /get_interfaces/:id
  def get_interfaces
    where_string = 'b.uuid="' +params[:id] + '"'

    if params[:without_cables]
      where_string += ' AND NOT (i)-[:PHYSICAL_CABLE]-(:Interface)'
    end

    if params[:without_patchcords]
      where_string += ' AND NOT (i)-[:PHYSICAL_PATCHCORD]-(:Interface)'
    end

    if params[:without_logical_links]
      where_string += ' AND NOT (i)-[:LOGICAL_LINK]-(:Interface)'
    end

    search = "(b)<-[]-(i:Interface)"
    query = ActiveGraph::Base.new_query.match(search).where(where_string).order('i.name')
    @interfaces = query.pluck(:i)
  end

  # Получаем список патчпанелей в стойке
  # GET /get_patchpanels/:id
  def get_patchpanels
    @patchpanels = Box.find(params[:id]).patchpanels.order(:name)
  end

  # Получаем список стоек в комнате
  # GET /get_boxes/:id
  def get_boxes
    @boxes = Room.find(params[:id]).boxes.order(:name)
  end

  # Делаем редирект либо на оборудование, либо на патчпанель
  # Используем в тех случаях, когда мы знаем id, но точно не знаем класс устройства
  def redirect_to_owner
    begin
      redirect_to device_path(Device.find(params[:id]))
    rescue
      redirect_to patchpanel_path(Patchpanel.find(params[:id]))
    end
  end

  # Поиск элементов из header
  # POST /search
  def search
    @page_title = ['Результаты поиска: ' + params[:search_string]]

    @devices = Device.as(:d)
                     .where("toLower(d.name) contains $search")
                     .params(search: params[:search_string].downcase )
                     .order('d.name')
    @buildings = Building.as(:b)
                         .where("toLower(b.name) contains $search")
                         .params(search: params[:search_string].downcase )
                         .order('b.name')
    @rooms = Room.as(:r)
                         .where("toLower(r.name) contains $search")
                          .params(search: params[:search_string].downcase )
                         .order('r.name')
    @boxes = Box.as(:b)
                         .where("toLower(b.name) contains $search")
                          .params(search: params[:search_string].downcase )
                         .order('b.name')
    @patchpanels = Patchpanel.as(:p)
                         .where("toLower(p.name) contains $search")
                          .params(search: params[:search_string].downcase )
                         .order('p.name')

    search_logical_link = "(d:Device)-[]-(:Interface)-[r:LOGICAL_LINK]-(:Interface)"
    query_logical_link = ActiveGraph::Base.new_query.match(search_logical_link)
                                          .where("toLower(d.name) contains $search")
                                          .params(search: params[:search_string].downcase )
    @logical_links = query_logical_link.pluck('distinct r')
  end
end