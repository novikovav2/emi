class BoxInRoom
  include ActiveGraph::Relationship

  from_class :Box
  to_class :Room
  type :BOX_IN_ROOM

  property :length, type: Integer, default: 100

end