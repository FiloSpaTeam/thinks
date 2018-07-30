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

class RatingsController < ApplicationController
  before_action :authenticate_thinker!

  before_action :set_task
  before_action :teammate!

  def create
    respond_to do |format|
      if @task.ratings.where(thinker: current_thinker).present?
        format.html { redirect_to project_task_path(@project, @task), notice: 'You have already expressed your think about.' }
        format.json { render :show, status: :ok, location: @task }
        
      else
        rating = Rating.new(rating_params)

        rating.task    = @task
        rating.thinker = current_thinker

        if rating.save
          format.html { redirect_to project_task_path(@project, @task), notice: 'Thanks for rating this work.' }
          format.json { render :show, status: :created, location: @task }
        else
          format.html { redirect_to project_task_path(@project, @task), alert: 'Your rating cannot be saved.' }
          format.json { render json: rating.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  private

  def rating_params
    allowed_params = [:value]

    params.require(:rating).permit(allowed_params)
  end

  def set_task
    @task = Task.includes(:project, :ratings).with_deleted.find(params[Enums::FiltersNames::TASK])
  end

  def teammate!
    unless @task.project.part_of_team?(current_thinker)
      flash[:alert] = 'You are not partecipating to this project as active member!'
      redirect_to project_tasks_path(@task.project)
    end
  end
end
