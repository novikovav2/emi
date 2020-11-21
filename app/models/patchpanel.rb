class Patchpanel
  include ActiveGraph::Node
  property :name, type: String
  enum material: [:copper, :optic]

  validates :name, presence: true

  has_one :out, :box, rel_class: :PatchpanelInBox
  has_many :in, :interfaces, rel_class: :InterfaceOfPatchpanel

end