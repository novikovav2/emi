class InterfaceOfDevice
  include ActiveGraph::Relationship

  from_class :Interface
  to_class :Device
  type :INTERFACE_OF_DEVICE

  property :length, type: Integer, default: 0

end