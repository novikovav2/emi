class RoomInBuilding
  include ActiveGraph::Relationship

  from_class :Room
  to_class :Building
  type :ROOMS_IN_BUILDING

  property :length, type: Integer, default: 1000

end