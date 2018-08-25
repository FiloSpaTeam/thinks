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

module OperationsHelper
  def done_button(operation)
    link_to done_project_task_operation_path(@project, operation.task, operation), :class => "pull-right btn actions", :role => "button", :title => t("done"), method: :put do
      content_tag(:span, "", :class => "glyphicon glyphicon-ok", "aria-hidden" => "true")
    end
  end

  def destroy_button(operation)
    link_to project_task_operation_path(@project, operation.task, operation), :class => "pull-right btn actions", :role => "button", :title => t("remove"), method: :delete do
      content_tag(:span, '', :class => 'glyphicon glyphicon-remove', 'aria-hidden' => 'true')
    end
  end
end
