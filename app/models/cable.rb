class Cable
  include ActiveGraph::Relationship

  from_class :Interface
  to_class :Interface
  type :PHYSICAL_CABLE

  after_create :set_material

  property :length, type: Integer, default: 25
  enum material: [:copper, :optic]

  validate :correct_interfaces_materials
  validate :validate_unique_cable_on_interface, on: :create

  # Проверяем, что связь создается между интерфейсами одного типа
  # Медь-медь или оптика-оптика
  def correct_interfaces_materials
    errors.add(:to_node) unless to_node.material == from_node.material
  end

  # Проверяем, что создаваемый кабель СКС единственный у этих интерфейсов
  def validate_unique_cable_on_interface
    errors.add(:to_node) if to_node.sks_to
    errors.add(:from_node) if from_node.sks_to
  end

  def set_material
    self.material = self.from_node.material
    self.save
  end


end