class MiscController < ApplicationController

  # GET /owners/:id
  def box_children
    search = "(b:Box)<-[]-(n)"
    query = ActiveGraph::Base.new_query.match(search).where('b.uuid="' +params[:id] + '"').order('n.name')
    @children = query.pluck(:n)
  end

  def get_interfaces
    search = "(b)<-[]-(i:Interface)"
    query = ActiveGraph::Base.new_query.match(search).where('b.uuid="' +params[:id] + '"').order('i.name')
    @interfaces = query.pluck(:i)
  end

  def redirect_to_owner
    begin
      redirect_to device_path(Device.find(params[:id]))
    rescue
      redirect_to patchpanel_path(Patchpanel.find(params[:id]))
    end
  end
end