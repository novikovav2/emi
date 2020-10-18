# Box = Rack
# We can not use "Rack" because it is a reserved term
class Box
  include ActiveGraph::Node
  property :name, type: String

  has_one :out, :room, type: :racks


end
