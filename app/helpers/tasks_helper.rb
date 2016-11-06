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

module TasksHelper
  def color_list_round_div(status)
    color_list = {
      'backlog'     => 'backlog',
      'release'     => 'info',
      'sprint'      => 'danger',
      'in_progress' => 'warning',
      'done'        => 'success'
    }

    color_list[status]
  end

  def color_list_group_item(status_task)
    if status_task.worker == current_thinker
      return "active"
    elsif !["backlog", "done"].include?(status_task.status.translation_code)
      if status_task.worker.nil?
        return "list-group-item-danger"
      else
        return "list-group-item-info"
      end
    end
  end

  def sd_class(sd)
    if sd >= 3
      "text-danger"
    elsif sd >= 1
      "text-warning"
    else
      "text-success"
    end
  end

  def goal_button(task)
    content_tag(:a, icon('crosshairs', :class => 'dark-grey fa-lg'), :class => task.goal.nil? ? "disabled btn" : "btn", :href => task.goal.nil? ? "javascript:;" : goal_path(task.goal), :title => task.goal.nil? ? t("no_goal") : task.goal.title, :role => "button")
  end
end
