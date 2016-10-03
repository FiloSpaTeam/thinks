# This file is part of Thinks.

# Thinks is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# Thinks is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero Public License for more details.

# You should have received a copy of the GNU Affero Public License
# along with Thinks.  If not, see <http://www.gnu.org/licenses/>.

# Copyright (c) 2015, Claudio Maradonna

module ApplicationHelper
  require 'redcarpet'
  require 'redcarpet/render_strip'
  require_dependency 'modules/redcarpet/render/cleanerhtml'

  def application_version
    version  = '0.1.14.375'
    date     = '2016.10.04'
    thinkers = Thinker.all.size
    content_tag(:span, "(Subscribers: #{thinkers})", class: 'hidden-xs hidden-sm pull-right text-muted') +
    content_tag(:small, "Version #{version}", class: 'text-muted pull-right hidden-xs ', title: date)
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

  def markdown(text, comment = false)
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
    renderer = Redcarpet::Render::HTML.new(options) if comment

    markdown = Redcarpet::Markdown.new(renderer, extensions)

    markdown.render(text).html_safe
  end

  def plain_text(markdown_text)
    md = Redcarpet::Markdown.new(Redcarpet::Render::StripDown, :space_after_headers => true)

    md.render(markdown_text)
  end

  def percentage_from_value_and_total(value, total)
    (100 * value) / total
  end

  def init_counter_textarea(id_textarea, id_counter)
    javascript_tag(
      "$(document).ready(function() {
          var textarea     = $('#{id_textarea}');
          var counter      = $('#{id_counter}');
          var max_length   = counter.data('maximum-length');

          textarea.keyup(function() {
            var diff = max_length - $(this).val().length;
            counter.text(diff);

            if (diff < 0) {
              counter.addClass('text-danger');
            } else {
              counter.removeClass('text-danger');
            }
          });
        });", defer: 'defer')
  end

  def highlights_searched_text(text, search)
    text
      .strip
      .gsub(/#{search}/i, "<u><span class='text-danger'>#{search}</u></span>")
      .html_safe
  end
end
