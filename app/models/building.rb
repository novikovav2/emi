class Building 
  include ActiveGraph::Node
  property :name, type: String
  property :address, type: String

  has_many :in, :rooms, rel_class: :RoomInBuilding

end
