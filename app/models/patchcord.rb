class Patchcord
  include ActiveGraph::Relationship


  from_class :Interface
  to_class :Interface
  type :PHYSICAL_PATCHCORD

  after_create :set_material
  after_create :connect_interfaces
  before_destroy :disconnect_interfaces

  property :length, type: Integer, default: 2
  enum material: [:copper, :optic]

  validate :correct_interfaces_materials
  validate :validate_unique_patchcord_on_interface, on: :create

  # Проверяем, что связь создается между интерфейсами одного типа
  # Медь-медь или оптика-оптика
  def correct_interfaces_materials
    errors.add(:to_node) unless to_node.material == from_node.material
  end

  # Проверяем, что создаваемый патчкорд единственный у этих интерфейсов
  def validate_unique_patchcord_on_interface
    errors.add(:to_node) if to_node.patchcorded_to
    errors.add(:from_node) if from_node.patchcorded_to
  end

  def set_material
    self.material = self.from_node.material
    self.save
  end

  def connect_interfaces
    from_node.update(connected: true)
    to_node.update(connected: true)
  end

  def disconnect_interfaces
    from_node.update(connected: false)
    to_node.update(connected: false)
  end

end