module BootstrapHelper
  def menu_divider
    content_tag :li, "", :class => :divider, :role => :separator
  end

  def dropdown_header t_string
    content_tag :li, t(t_string), :class => "dropdown-header"
  end
end
