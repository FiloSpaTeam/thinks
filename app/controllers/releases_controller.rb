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

class ReleasesController < ApplicationController
  before_action :authenticate_thinker!

  before_action :set_project, only: [:new, :index, :create]

  def index
    @filterrific = initialize_filterrific(
      Release,
      params[:filterrific],
      select_options: {}
    ) || return
    @releases = @filterrific
                .find.unscoped
                .where(project: @project)
                .order('end_at asc')
                .page(params[:page])
  rescue ActiveRecord::RecordNotFound => e
    # There is an issue with the persisted param_set. Reset it.
    puts "Had to reset filterrific params: #{e.message}"
    redirect_to(reset_filterrific_url(format: :html)) && return
  end

  def new
    if !@project.assigned_roles.where(thinker: current_thinker).where(team_role: TeamRole.scrum_master.first).exists?
      respond_to do |format|
        format.html { redirect_to project_releases_path(@project), alert: "You are not the Scrum Master." }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end

    @release         = Release.new
    @release.project = @project

    @project_form = @project
  end

  def edit
    if !@project.assigned_roles.where(thinker: current_thinker).where(team_role: TeamRole.scrum_master.first).exists?
      respond_to do |format|
        format.html { redirect_to project_releases_path(@project), alert: "You are not the Scrum Master." }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end

    @project_form = nil
    @project      = @release.project
  end
end
