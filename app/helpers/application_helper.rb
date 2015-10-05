module ApplicationHelper
  def active_link_if_current(path)
    return "active" if current_page?(path)
  end

  def set_has_error_form_group(resource, name)
    'has-error' if resource.errors.include?(name)
  end
end
