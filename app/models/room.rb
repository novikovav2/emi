class Room 
  include ActiveGraph::Node
  property :name, type: String
  property :floor, type: Integer

  validates :name, presence: true
  validates :floor, format: { with: /\A\d+\z/, message: "Integer only. No letter allowed." }
  before_destroy :validate_on_destroy, prepend: true do
    throw(:abort) if errors.present?
  end

  has_one :out, :building, rel_class: :RoomInBuilding
  has_many :in, :boxes, rel_class: :BoxInRoom

  private
  def validate_on_destroy
    if self.boxes.first.nil?
      return true
    else
      self.errors.add :base, "Room has boxes. Destroy them first"
    end
    return false
  end


end
