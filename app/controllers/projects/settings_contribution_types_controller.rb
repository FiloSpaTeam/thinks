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

# Copyright (c) 2017, Claudio Maradonna

class Projects::SettingsContributionTypesController < ApplicationController
  include ProjectsHelper

  before_action :authenticate_thinker!
  before_action :set_project
  before_action :thinker!

  def create
    respond_to do |format|
      @project.skip_motto_validation = true

      if @project.update(contribution_type_params)
        format.html { redirect_to project_settings_contribution_types_path(@project), notice: 'Project was successfully updated.' }
        format.json { render :show, status: :ok, location: @project }
      else
        set_form_errors(@project)

        format.html { render :index }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def contribution_type_params
    params
      .require(:project)
      .permit(:contribution_type, :contribution_text, :recruitment_text)
  end
end
