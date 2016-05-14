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
end
