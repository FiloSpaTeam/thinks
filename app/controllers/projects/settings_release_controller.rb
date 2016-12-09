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

class Projects::SettingsReleaseController < ApplicationController
  include ProjectsHelper

  before_action :authenticate_thinker!
  before_action :set_project
  before_action :thinker!

  def index
  end

  def create
    respond_to do |format|
      if @project.started?
        if @project.release_at != release_params[:release_at]
          format.html { redirect_to project_settings_release_index_path(@project), error: t(:cant_update_release_at) }
          format.json { render json: @project.errors, status: :cant_update_release_at }
        end
      end

      if @project.update(release_params)
        format.html { redirect_to project_settings_release_index_path(@project), notice: 'Project was successfully updated.' }
        format.json { render :show, status: :ok, location: @project }
      else
        format.html { render :edit }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def release_params
    params.require(:project).permit(:minimum_team_number, :release_at, :license_id, :category_id)
  end
end
