class Room 
  include ActiveGraph::Node
  property :name, type: String
  property :floor, type: Integer

  has_one :out, :building, type: :rooms
  has_many :in, :boxes, type: :racks


end
