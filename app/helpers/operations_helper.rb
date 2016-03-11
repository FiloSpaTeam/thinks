module OperationsHelper
  def done_button(operation)
    link_to done_operation_path(operation), :class => "pull-right btn actions", :role => "button", :title => t("done"), method: :put do
      content_tag(:span, "", :class => "glyphicon glyphicon-ok", "aria-hidden" => "true")
    end
  end

  def destroy_button(operation)
    link_to operation_path(operation), :class => "pull-right btn actions", :role => "button", :title => t("remove"), method: :delete do
      content_tag(:span, '', :class => 'glyphicon glyphicon-remove', 'aria-hidden' => 'true')
    end
  end
end
