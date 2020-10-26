class Interface 
  include ActiveGraph::Node
  property :name, type: String
  enum type: [:copper, :optic]

  has_one :out, :device, type: :interface_of_device

end
