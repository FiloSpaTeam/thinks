module CommentsHelper
  def edit_button(comment)
    link_to edit_comment_path(comment), remote: true, :class => "pull-right btn", :role => "button", :title => t("edit"), method: :get do
      content_tag(:span, '', :class => 'glyphicon glyphicon-pencil dark-grey', 'aria-hidden' => 'true')
    end
  end
end
