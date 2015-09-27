module DeviseHelper
  def devise_error_messages!
    return "" if resource.errors.empty?

    messages = resource.errors.full_messages.map { |msg| content_tag(:li, msg) }.join
    flash.now[:error] = "<ul>#{messages}</ul>"

    return ''
  end
end
