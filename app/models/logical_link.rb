class LogicalLink
  include ActiveGraph::Relationship

  from_class :Interface
  to_class :Interface

  validate :correct_interfaces_materials

  # Проверяем, что связь создается между интерфейсами одного типа
  # Медь-медь или оптика-оптика
  def correct_interfaces_materials
    errors.add(:to_node) unless to_node.material == from_node.material
  end
end