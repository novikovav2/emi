module ApplicationHelper
  def sort_angle(order)
    if order == 0
      "<i class='fas fa-angle-down'></i>".html_safe
    else
      '<i class="fas fa-angle-up"></i>'.html_safe
    end
  end


end
