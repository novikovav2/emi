class Device 
  include ActiveGraph::Node
  property :name, type: String

  validates :name, presence: true
  before_destroy :validate_on_destroy, prepend: true do
    throw(:abort) if errors.present?
  end

  has_one :out, :box, rel_class: :DeviceInBox
  has_many :in, :interfaces, rel_class: :InterfaceOfDevice


  private
  def validate_on_destroy
    if self.interfaces.first.nil?
      return true
    else
      self.errors.add :base, "Device has interfaces. Destroy them first"
    end
    return false
  end

end
