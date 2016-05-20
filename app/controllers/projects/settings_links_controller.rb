class Projects::SettingsLinksController < ApplicationController
  include ProjectsHelper

  before_action :authenticate_thinker!
  before_action :set_project
  before_action :thinker!

  def index
  end

  def create
    respond_to do |format|
      if @project.update(links_params)
        format.html { redirect_to project_settings_links_path(@project), notice: 'Project was successfully updated.' }
        format.json { render :show, status: :ok, location: @project }
      else
        format.html { render :edit }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def links_params
    params.require(:project).permit(:home_url, :documentation_url, :source_code_url, :donate_button)
  end
end
