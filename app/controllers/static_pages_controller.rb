class StaticPagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_page_title

  def root
    @buildings = Building.count
    @rooms = Room.count
    @boxes = Box.count
    @patchpanels = Patchpanel.count
    @devices = Device.count
    @cables = ActiveGraph::Base.new_query.match("()-[r:PHYSICAL_CABLE]->()").pluck('count(r)').first
    @patchcords = ActiveGraph::Base.new_query.match("()-[r:PHYSICAL_PATCHCORD]->()").pluck('count(r)').first
    @logical_links = ActiveGraph::Base.new_query.match("()-[r:LOGICAL_LINK]->()").pluck('count(r)').first
  end

  private

  def set_page_title
    @page_title = ['Главная']
  end
end
