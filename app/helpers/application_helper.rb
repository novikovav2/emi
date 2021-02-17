module ApplicationHelper
  def sort_angle(order)
    if order == 0
      "<i class='fas fa-angle-down'></i>".html_safe
    else
      '<i class="fas fa-angle-up"></i>'.html_safe
    end
  end

  def human_material(material)
    if material == :optic
      'OM3'
    elsif material == :copper
      'RJ45'
    end
  end

  def pretty_status(status)
    if status > 0
      "<i class='fas fa-check'></i> Да".html_safe
    else
      "<i class='fas fa-exclamation-triangle'></i> Нет".html_safe
    end
  end
end
