# Box = Rack
# We can not use "Rack" because it is a reserved term
class Box
  include ActiveGraph::Node
  property :name, type: String

  validates :name, presence: true
  before_destroy :validate_on_destroy, prepend: true do
    throw(:abort) if errors.present?
  end

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

  private
  def validate_on_destroy
    if self.devices.first.nil? and self.patchpanels.first.nil?
      return true
    elsif self.devices.first
      self.errors.add :base, "Box has devices. Destroy them first"
    elsif self.patchpanels.first
      self.errors.add :base, "Box has patchpanels. Destroy them first"
    end
    return false
  end

end
