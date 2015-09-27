module BootstrapHelper
  def menu_divider
    content_tag :li, "", :class => :divider, :role => :separator
  end
end
