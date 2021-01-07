class Building 
  include ActiveGraph::Node
  property :name, type: String
  property :address, type: String

  validates :name, presence: true
  before_destroy :validate_on_destroy, prepend: true do
    throw(:abort) if errors.present?
  end

  has_many :in, :rooms, rel_class: :RoomInBuilding

  private
  def validate_on_destroy
    if self.rooms.first.nil?
      return true
    else
      self.errors.add :base, "Building has rooms. Destroy them first"
    end
    return false
  end

end
