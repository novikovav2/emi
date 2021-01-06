module LogicalLinksHelper
  def human_types(material)
    case material
      when 'patchcord'
        'Патчкорд'
      when 'sks'
        'СКС'
      when 'new_patchcord'
        'Новый патчкорд'
    end
  end
end
