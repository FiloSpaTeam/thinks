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

  def apply_filters(scope, params)
    scope = scope.with_goal(params[:goal_id]) if params.key?(:goal_id) &&
                                                 params[:goal_id].present?
    scope = scope.with_release(params[:release_id]) if params.key?(:release_id) &&
                                                       params[:release_id].present?
    scope = scope.with_thinker(params[:thinker_id]) if params.key?(:thinker_id) &&
                                                       params[:thinker_id].present?
    scope = scope.with_worker(params[:worker_id]) if params.key?(:worker_id) &&
                                                     params[:worker_id].present?

    scope = scope.search_title_and_description(params[:search_title_and_description]) if params.key?(:search_title_and_description) &&
                                                                                         params[:search_title_and_description].present?


    scope = scope.status_progress(params[:status_id]) if params.key?(:status_id) &&
                                                         params[:status_id].present?

    scope = scope.with_deleted_at if params.key?(:with_deleted_at) &&
                                     params[:with_deleted_at].present?

    scope
  end

  def apply_sorter(scope, params)
    key       = params.keys.last
    # direction = params[:users_smart_listing][:sort].values.last

    # TODO
    # I have to filter the tasks that i didn't vote
    case key
    when 'workload'
      scope = scope
              .joins(:votes)
              .where('votes.thinker_id = ? OR tasks.status_id = ?',
                     current_thinker.id,
                     Status.done.first)
              .preload(:votes)
    end

    scope
  end
end
