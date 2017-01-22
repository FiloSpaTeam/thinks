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
    content_tag(:li) do
      link_to edit_comment_path(comment), remote: true, method: :get do
        icon('pencil', class: 'dark-grey') +
          content_tag(:span, t('edit'), class: 'padding-left-5')
      end
    end
  end

  def delete_button(comment)
    content_tag(:li) do
      link_to comment_path(comment), remote: true, method: :delete, data: { confirm: 'Are you sure? Your comment will be deleted permanently with your vote.' } do
        icon('trash', class: 'dark-grey') +
          content_tag(:span, t('delete'), class: 'padding-left-5')
      end
    end
  end

  def like_button(comment)
    content_tag(:div, class: 'form-group') do
      if comment.current_thinker?(current_thinker)
        link_to 'javascript:;', :title => t('you_cannot_vote_yourself') do
          icon('thumbs-up', class: 'fa-lg dark-grey') +
            like_count(comment.impressionist_count)
        end
      elsif comment.impressionist_count(user_id: current_thinker.id).zero?
        link_to like_comment_path(comment), :title => t('vote') do
          icon('thumbs-up', class: 'fa-lg dark-grey') +
            like_count(comment.impressionist_count)
        end
      else
        link_to 'javascript:;', :title => t('you_voted_yet') do
          icon('thumbs-up', class: 'fa-lg dark-grey') +
            like_count(comment.impressionist_count)
        end
      end
    end
  end

  def approve_button(comment)
    content_tag(:div, class: 'form-group') do
      link_to (comment.approved && comment.task.done? ? 'javascript:;' : approve_comment_path(comment)), class: 'btn-approve', 'data-approved' => comment.approved.to_s, :title => t('approve') do
        icon('check', class: "fa-lg #{comment.approved ? 'dark-grey' : ''}")
      end
    end
  end
end
