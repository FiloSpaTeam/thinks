class Projects::SettingsSprintController < ApplicationController
  include ProjectsHelper

  before_action :authenticate_thinker!
  before_action :set_project
  before_action :thinker!

  def index
  end

  def create
    respond_to do |format|
      if @project.update(sprint_params)
        format.html { redirect_to project_settings_sprint_index_path(@project), notice: 'Project was successfully updated.' }
        format.json { render :show, status: :ok, location: @project }
      else
        format.html { render :edit }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def sprint_params
    params.require(:project).permit(:cycle_id)
  end
end
