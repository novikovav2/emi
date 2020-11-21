class PatchpanelInBox
  include ActiveGraph::Relationship

  from_class :Patchpanel
  to_class :Box
  type :PATCHPANEL_IN_BOX

  property :length, type: Integer, default: 5


end