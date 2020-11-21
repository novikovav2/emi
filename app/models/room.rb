class Room 
  include ActiveGraph::Node
  property :name, type: String
  property :floor, type: Integer

  validates :name, presence: true
  validates :floor, format: { with: /\A\d+\z/, message: "Integer only. No letter allowed." }

  has_one :out, :building, rel_class: :RoomInBuilding
  has_many :in, :boxes, rel_class: :BoxInRoom


end
