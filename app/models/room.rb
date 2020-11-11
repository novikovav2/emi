class Room 
  include ActiveGraph::Node
  property :name, type: String
  property :floor, type: Integer

  has_one :out, :building, rel_class: :RoomInBuilding
  has_many :in, :boxes, rel_class: :BoxInRoom


end
