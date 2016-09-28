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

class Projects::SettingsFatherController < ApplicationController
  include ProjectsHelper

  before_action :authenticate_thinker!
  before_action :set_project
  before_action :thinker!

  def index
  end

  def create
    project_master = Project.find_by(father_params)

    respond_to do |format|
      if project_master.nil?
        format.html { redirect_to project_settings_father_index_path(@project), alert: 'Serial is not valid.' }
        format.json { render json: {}, status: :unprocessable_entity }
      else
        @project.project = project_master

        @project.save

        format.html { redirect_to project_settings_father_index_path(@project), notice: 'Project linked.' }
        format.json { render :index, status: :created }
      end
    end
  end

  def destroy
    respond_to do |format|
      @project.project = nil
      @project.save

      format.html { redirect_to project_settings_father_index_path(@project), notice: 'At this moment is no longer a subproject.' }
      format.json { head :no_content }
    end
  end

  private

  def father_params
    allowed_params = [:serial]

    params.require(:project).permit(allowed_params)
  end
end
