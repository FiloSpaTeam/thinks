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

module ProjectsHelper
  def creator?(id)
    thinker_signed_in? && id == current_thinker.id
  end

  def progress_bar_color(percentage)
    case percentage
    when -Float::INFINITY..25
      "progress-bar-danger"
    when 25..50
      "progress-bar-warning"
    when 100
      "progress-bar-success"
    end
  end

  def random_color
  end

  def set_project
    @project = Project.friendly.find(params[:project_id] || params[:id])
  end

  def thinker!
    if @project.thinker != current_thinker
      flash[:alert] = 'You are not the founder!'
      redirect_to project_path(@project)
    end
  end

  def scrum_master?(project)
    return false if project
                    .assigned_roles
                    .where(thinker: current_thinker)
                    .where('team_role_id IN (?,?)',
                           TeamRole.scrum_master.first,
                           TeamRole.product_owner.first)
                    .first
                    .nil?
    true
  end

  def apply_filters(scope, params)
    scope = scope.with_title_or_description(params[:title_or_description]) if params.key?(:title_or_description) &&
                                                                              params[:title_or_description].present?

    scope = scope.with_category(params[:category_id]) if params.key?(:category_id) &&
                                                         params[:category_id].present?

    scope = scope.order(created_at: :desc) if params.key?(:recent) &&
                                              params[:recent].present?

    if params.key?(:most_active) &&
       params[:most_active].present?
      scope = scope
              .order(impressions_count: :desc)
              .where('impressions_count > 0')
    end

    if params.key?(:most_followed) &&
       params[:most_followed].present?
      scope = scope
              .joins(:contributions)
              .group('projects.id')
              .order('count(contributions.id) desc')
    end

    scope
  end
end
