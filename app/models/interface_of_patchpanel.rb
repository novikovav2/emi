class InterfaceOfPatchpanel
  include ActiveGraph::Relationship

  from_class :Interface
  to_class :Patchpanel
  type :INTERFACE_OF_PATCHPANEL

  property :length, type: Integer, default: 0

end