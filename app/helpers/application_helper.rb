module ApplicationHelper
  require_dependency "modules/redcarpet/render/cleanerhtml"

  def application_version
    version = "0.1.0.2"
    "Version: #{version}"
  end

  def link_to_button(path, text, icon_source)
    link_to(path, :class => "#{active_link_if_current(path)} pull-right btn btn-default", :title => t(text), :role => "button") do
      icon(icon_source, :class => "dark-grey") +
      label_tag(nil, t(text), :class => "hidden-xs")
    end
  end

  def active_link_if_current(path)
    return "active" if current_page?(path)
  end

  def set_has_error_form_group(resource, name)
    'has-error' if resource.errors.include?(name)
  end

  def markdown(text)
    options = {
      filter_html:         true,
      hard_wrap:           true,
      link_attributes:     { rel: 'nofollow', target: "_blank" },
      space_after_headers: true,
      fenced_code_blocks:  true,
      prettify:            true
    }

    extensions = {
      autolink:                     true,
      superscript:                  true,
      disable_indented_code_blocks: true
    }

    renderer = Redcarpet::Render::CleanerHTML.new(options)
    markdown = Redcarpet::Markdown.new(renderer, extensions)

    markdown.render(text).html_safe
  end
end
