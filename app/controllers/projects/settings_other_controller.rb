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

class Projects::SettingsOtherController < ApplicationController
  include ProjectsHelper

  before_action :authenticate_thinker!
  before_action :set_project
  before_action :thinker!

  def index
  end

  def create
    @new_owner = Thinker.find_by(email: params[:owner_email])

    respond_to do |format|
      if @new_owner.nil?
        format.html { redirect_to project_settings_other_index_path(@project), alert: 'Email is not valid.' }
      elsif @new_owner == @project.thinker
        format.html { redirect_to project_settings_other_index_path(@project), alert: 'Want you migrate your project to yourself? Strange operation.' }
      else
        @project.skip_motto_validation = true

        @project.thinker = @new_owner
        @project.save

        format.html { redirect_to project_path(@project), notice: 'Migration done. You can continue to contribute changing partecipation settings. Do your best!' }
      end
    end
  end
end
