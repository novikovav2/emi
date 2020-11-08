class Interface 
  include ActiveGraph::Node
  property :name, type: String
  enum material: [:copper, :optic]
  property :connected, type: Boolean, default: false

  has_one :out, :device, type: :interface_of_device

  has_one :both, :logical_linked_to, rel_class: :LogicalLink
  has_one :both, :pathcorded_to, rel_class: :Patchcord
  has_one :both, :sks_to, rel_class: :Cable

end
