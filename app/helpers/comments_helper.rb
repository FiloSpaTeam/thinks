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

  def like_button(comment)
    likes = comment.likes
    likes.length
    if comment.current_thinker?(current_thinker)
      link_to 'javascript:;', :class => "pull-right btn", :role => "button", :title => t("you_cannot_vote_yourself") do
        content_tag(:span, "", :class => "glyphicon glyphicon-arrow-up dark-grey", "aria-hidden" => "true") +
        like_count(likes.length)
      end
    elsif likes.current_thinker(current_thinker).present?
      link_to 'javascript:;', :class => "pull-right btn", :role => "button", :title => t("you_voted_yet") do
        content_tag(:span, "", :class => "glyphicon glyphicon-arrow-up dark-grey", "aria-hidden" => "true") +
        like_count(likes.length)
      end
    else
      link_to comment_likes_path(comment), :class => "pull-right btn", :role => "button", :title => t("vote"), method: :post do
        content_tag(:span, "", :class => "glyphicon glyphicon-arrow-up", "aria-hidden" => "true") +
        like_count(likes.length)
      end
    end
  end

  def approve_button(comment)
    link_to (comment.approved && comment.task.done? ? 'javascript:;' : approve_comment_path(comment)), :class => 'pull-right btn btn-approve', :role => 'button', 'data-approved' => comment.approved.to_s, :title => t('approve') do
      content_tag(:span, "", :class => "glyphicon glyphicon-ok #{ comment.approved ? 'dark-grey' : '' }", "aria-hidden" => "true")
    end
  end
end
