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

module GoalsHelper
  def tasks_title(goal)
    pluralize(goal.tasks.count, t('goals.task').downcase) + ", " +
      pluralize(goal.tasks.is_done.count, t('tasks.statuses.done').downcase) +  ", " +
      goal.tasks.in_progress.count.to_s + " " + t('tasks.statuses.in_progress').downcase
  end

  def release_btn_title(tasks_ready)
    'Put ' + pluralize(tasks_ready.count, 'task') + ' in Sprint automatically'
  end

  def apply_filters(scope, params)
    scope = scope.search_title_and_description(params[:search_title_and_description]) if params.key?(:search_title_and_description) &&
                                                                                         params[:search_title_and_description].present?

    scope = scope.with_task(params[Enums::FiltersNames::TASK]) if params.key?(Enums::FiltersNames::TASK) &&
                                                 params[Enums::FiltersNames::TASK].present?

    scope = scope.progress_lower_than(params[:progress_lower_than]) if params.key?(:progress_lower_than) &&
                                                                       params[:progress_lower_than].present?

    if params.key?(Enums::FiltersNames::DELETED_AT) &&
       params[Enums::FiltersNames::DELETED_AT].present? &&
       params[Enums::FiltersNames::DELETED_AT]
      scope = scope.with_deleted_at
    else
      params.delete Enums::FiltersNames::DELETED_AT
    end

    scope
  end
end
