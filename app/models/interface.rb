class Interface 
  include ActiveGraph::Node
  property :name, type: String

  has_one :out, :device, type: :interface_of_device

end
