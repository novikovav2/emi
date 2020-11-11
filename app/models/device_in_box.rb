class DeviceInBox
  include ActiveGraph::Relationship

  from_class :Device
  to_class :Box
  type :DEVICE_IN_BOX

  property :length, type: Integer, default: 5


end