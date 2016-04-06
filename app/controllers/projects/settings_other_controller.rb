class Projects::SettingsOtherController < ApplicationController
  include ProjectsHelper

  before_action :authenticate_thinker!
  before_action :set_project

  def index
  end

  def create
    @new_owner = Thinker.find_by(email: params[:owner_email])

    respond_to do |format|
      unless creator?(@project.thinker.id)
        format.html { redirect_to project_path(@project), error: t(:cant_update) }
        format.json { render json: @project.errors, status: :cant_update }
      end

      if @new_owner.nil?
        format.html { redirect_to project_settings_other_index_path(@project), error: 'Email is not valid.' }
      elsif @new_owner == @project.thinker
        format.html { redirect_to project_settings_other_index_path(@project), error: 'Want you migrate your project to yourself? Strange operation.' }
      else
        @project.thinker = @new_owner
        @project.save

        format.html { redirect_to project_settings_other_index_path(@project), notice: 'Migration done. You can continue to contribute changing partecipation settings. Do your best!' }
      end
    end
  end
end
