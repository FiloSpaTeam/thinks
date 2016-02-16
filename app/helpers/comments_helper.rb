module CommentsHelper
  def edit_button(comment)
    link_to edit_comment_path(comment), remote: true, :class => "pull-right btn", :role => "button", :title => t("edit"), method: :get do
      content_tag(:span, '', :class => 'glyphicon glyphicon-pencil dark-grey', 'aria-hidden' => 'true')
    end
  end

  def delete_button(comment)
    link_to comment_path(comment), :class => "pull-right btn", :role => "button", :title => t("delete"), method: :delete, data: { confirm: 'Are you sure? Your idea will be deleted permanently with your vote.' } do
      content_tag(:span, '', :class => 'glyphicon glyphicon-remove dark-grey', 'aria-hidden' => 'true')
    end
  end
end
