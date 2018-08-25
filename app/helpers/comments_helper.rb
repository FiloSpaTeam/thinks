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
    link_to edit_project_task_comment_path(comment.task.project, comment.task, comment), remote: true, method: :get, class: 'dropdown-item small' do
      icon('fas', 'edit', t('edit'), class: 'text-dark')
    end
  end

  def delete_button(comment)
    content_tag(:li) do
      link_to project_task_comment_path(comment.task.project, comment.task, comment), method: :delete, data: { confirm: t('comments.confirm_delete') }, class: 'dropdown-item small' do
        icon('fas', 'eraser', t('delete'), class: 'text-dark')
      end
    end
  end

  def like_button(comment)
    if comment.current_thinker?(current_thinker)
      link_to 'javascript:;', :title => t('comments.you_cannot_vote_yourself'), class: 'dropdown-item small' do
        icon('fas', 'thumbs-up', t('comments.likes', count: comment.impressionist_count, text: like_count(comment.impressionist_count)),class: 'text-dark')
      end
    elsif comment.impressionist_count(user_id: current_thinker.id).zero?
      link_to like_comment_path(comment), :title => t('comments.vote') do
        icon('fas', 'thumbs-up', t('comments.likes', count: comment.impressionist_count, text: like_count(comment.impressionist_count)),class: 'text-dark')
      end
    else
      link_to 'javascript:;', :title => t('comments.you_voted_yet') do
        icon('fas', 'thumbs-up', t('comments.likes', count: comment.impressionist_count, text: like_count(comment.impressionist_count)),class: 'text-dark')
      end
    end
  end

  def approve_button(comment)
    link_to (comment.approved && comment.task.done? ? 'javascript:;' : ''), class: 'dropdown-item small btn-approve', 'data-approved' => comment.approved.to_s, :title => t('approve') do
      icon('fas', 'check', class: "#{comment.approved ? 'text-dark' : ''}")
    end
  end

  def like_count(number)
    case number
    when 0..20 then number.to_s
    when 20..50 then '20+'
    when 50..100 then '50+'
    when 100..500 then '100+'
    when 500..1000 then '500+'
    when 1000..Float::INFINITY then '1000+'
    end
  end
end
