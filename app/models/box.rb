# Box = Rack
# We can not use "Rack" because it is a reserved term
class Box
  include ActiveGraph::Node
  property :name, type: String

  validates :name, presence: true

  has_one :out, :room, rel_class: :BoxInRoom
  has_many :in, :devices, rel_class: :DeviceInBox
  has_many :in, :patchpanels, rel_class: :PatchpanelInBox

  def children
    result = []
    self.devices.each do |d|
      result << d
    end
    self.patchpanels.each do |p|
      result << p
    end

    return result
  end
end
