class Device 
  include ActiveGraph::Node
  property :name, type: String

  has_one :out, :box, type: :device_in_rack
  has_many :in, :interfaces, type: :interface_of_device

end
