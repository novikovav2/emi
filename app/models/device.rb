class Device 
  include ActiveGraph::Node
  property :name, type: String

  validates :name, presence: true

  has_one :out, :box, rel_class: :DeviceInBox
  has_many :in, :interfaces, rel_class: :InterfaceOfDevice



end
