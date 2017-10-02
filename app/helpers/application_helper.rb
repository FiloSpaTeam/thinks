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
    version = '0.1.82.1447'
    content_tag(:div, 'v' + version, style: 'color: #BCBCBC;', class: 'margin-top-50 hidden-xs')
  end

  def flash_class(level)
    case level
    when 'notice' then 'text-info'
    when 'success' then 'text-success'
    when 'error' then 'text-danger'
    when 'alert' then 'text-danger'
    end
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
      tables:                       true,
      no_intra_emphasis:            true,
      strikethrough:                true
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

  def init_counter_textarea
    javascript_tag(
      "$(document).ready(function() {
          var textarea     = $('.has-counter');

          textarea.keyup(function() {
            var counter      = $(this)
                                 .parent()
                                 .find('.counter');
            var max_length   = counter.data('maximum-length');
            var diff         = max_length - $(this).val().length;
            counter.text(diff);

            if (diff < 0) {
              counter.addClass('text-danger');
            } else {
              counter.removeClass('text-danger');
            }
          });
        });", defer: 'defer');
  end

  def highlights_searched_text(text, search)
    return text if search.to_s.empty?

    if text.present?
      text
        .strip
        .gsub(/#{search}/i) { |s| "<u><span class='text-danger'>#{s}</span></u>" }
        .html_safe
    end
  end

  def active_filter?(filter, value = nil)
    active  = false
    f_value = filter_value(filter)

    unless f_value.nil?
      active = true if value.nil? || f_value == value.to_s
    end

    active
  end

  def any_filter?(filter, except = [])
    any = false
    unless filter.nil?
      filter_c = filter.dup

      except.each { |k| filter_c.delete k }

      any = filter_c.any?
    end

    any
  end

  def filter_value(filter, key = :filters)
    params[key][filter] if params.key?(key) &&
                           params[key].key?(filter) &&
                           params[key][filter].present?
  end

  def url_for_filter(key, value, conflicting_filters = [])
    new_params = params.dup

    new_params[:filters] = {} unless new_params.key?(:filters)
    new_params[:filters] = new_params[:filters].except(key)
    conflicting_filters.each do |filter|
      new_params[:filters] = new_params[:filters].except(filter)
    end
    new_params[:filters] = new_params[:filters].reject { |_, v| v.blank? }
    new_params[:filters] = new_params[:filters].merge(key => value)

    new_params
  end
end
