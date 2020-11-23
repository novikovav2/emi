class Interface 
  include ActiveGraph::Node
  property :name, type: String
  enum material: [:copper, :optic]
  property :connected, type: Boolean, default: false

  validates :name, presence: true

  has_one :out, :device, rel_class: :InterfaceOfDevice
  has_one :out, :patchpanel, rel_class: :InterfaceOfPatchpanel
  has_one :both, :logical_linked_to, rel_class: :LogicalLink
  has_one :both, :patchcorded_to, rel_class: :Patchcord
  has_one :both, :sks_to, rel_class: :Cable


  # Находим куда физически подключен этот интерфейс
    def connected_to
      if self.connected and self.device
        request = ActiveGraph::Base.query('match
                                        (start {uuid: $start_id})-
                                        [r:PHYSICAL_PATCHCORD|PHYSICAL_CABLE *1..100]-
                                        (end)
                                        RETURN last(collect(end))', start_id: self.id)
        return request.first.values[0]
      else
        return nil
      end
      end

  def owner
    if self.device
      return self.device
    else
      return self.patchpanel
    end
  end
end
