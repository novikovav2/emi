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
end