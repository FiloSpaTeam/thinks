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

  def apply_filters(scope, params)
    scope = scope.with_goal(params[Enums::FiltersNames::GOAL]) if
      params.key?(Enums::FiltersNames::GOAL) &&
      params[Enums::FiltersNames::GOAL].present?
    scope = scope.with_release(params[Enums::FiltersNames::RELEASE]) if
      params.key?(Enums::FiltersNames::RELEASE) &&
      params[Enums::FiltersNames::RELEASE].present?
    scope = scope.with_sprint(params[Enums::FiltersNames::SPRINT]) if
      params.key?(Enums::FiltersNames::SPRINT) &&
      params[Enums::FiltersNames::SPRINT].present?
    scope = scope.with_thinker(params[Enums::FiltersNames::THINKER]) if
      params.key?(Enums::FiltersNames::THINKER) &&
      params[Enums::FiltersNames::THINKER].present?
    scope = scope.with_worker(params[Enums::FiltersNames::WORKER]) if
      params.key?(Enums::FiltersNames::WORKER) &&
      params[Enums::FiltersNames::WORKER].present?

    scope = scope.search_title_and_description(params[:search_title_and_description]) if
      params.key?(:search_title_and_description) &&
      params[:search_title_and_description].present?

    scope = scope.status_progress(params[Enums::FiltersNames::STATUS]) if
      params.key?(Enums::FiltersNames::STATUS) &&
      params[Enums::FiltersNames::STATUS].present?

    if params.key?(Enums::FiltersNames::DELETED_AT) &&
       params[Enums::FiltersNames::DELETED_AT].present? &&
       params[Enums::FiltersNames::DELETED_AT]
      scope = scope.with_deleted_at
    else
      params.delete Enums::FiltersNames::DELETED_AT
    end

    scope
  end

  def apply_sorter(scope, params)
    key = params.keys.last
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

  def std_deviation_button(task)
    link_to 'javascript:;', title: task.standard_deviation, role: 'button' do
      icon('fas', 'bullseye', class: 'text-dark')
    end
  end

  def project_button(task)
    if task.project.present?
      link_to project_path(task.project), title: task.project.title, role: 'button' do
        icon('fas', 'folder', class: 'text-dark')
      end
    end
  end

  def goal_button(task)
    link_to project_goal_path(task.project, task.goal), title: task.goal.title, role: 'button' do
      icon('crosshairs', class: 'dark-grey')
    end
  end

  def children_button
    link_to 'javascript:;', title: 'This task has children.' do
      icon('sitemap', class: 'dark-grey')
    end
  end
end
