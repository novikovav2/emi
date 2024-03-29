class LogicalLink
  include ActiveGraph::Relationship

  from_class :Interface
  to_class :Interface

  validate :correct_interfaces_materials
  validate :validate_unique_logical_links_on_interface, on: :create

  # Проверяем, что связь создается между интерфейсами одного типа
  # Медь-медь или оптика-оптика
  def correct_interfaces_materials
    errors.add(:to_node) unless to_node.material == from_node.material
  end

  # Проверяем, что создаваемая логическая связь единственная у этих интерфейсов
  def validate_unique_logical_links_on_interface
    errors.add(:to_node) if to_node.logical_linked_to
    errors.add(:from_node) if from_node.logical_linked_to
  end


  def connected?
    result = false
    if self.from_node.connected and self.to_node.connected
      request = ActiveGraph::Base.query(
                  'match (start {uuid: $start_id})-
                  [r:PHYSICAL_PATCHCORD|PHYSICAL_CABLE *1..100]-
                  (end {uuid: $end_id}) RETURN r',
                  start_id: self.from_node.id, end_id: self.to_node.id)

      if request.first
        result = true
      end
    end
    return result
  end

end