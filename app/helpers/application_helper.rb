module ApplicationHelper
  def active_link_if_current(path)
    return "active" if current_page?(path)
  end
end
