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
  before_action :set_validators_for_form_help, only: [:new, :edit]
  before_action :set_release, only: [:show, :edit, :update, :destroy]

  def index
    @filterrific = initialize_filterrific(
      Release.includes(:tasks),
      params[:filterrific],
      select_options: {}
    ) || return
    @releases = @filterrific
                .find.unscoped
                .where(project: @project)
                .order('end_at asc')
                .page(params[:page])

    @active_filters = [
      Enums::Filters::SEARCH_TASK,
      Enums::Filters::PROGRESS_LOWER_THAN
    ]
  rescue ActiveRecord::RecordNotFound => e
    # There is an issue with the persisted param_set. Reset it.
    puts "Had to reset filterrific params: #{e.message}"
    redirect_to(reset_filterrific_url(format: :html)) && return
  end

  def new
    unless @project
           .assigned_roles
           .where(thinker: current_thinker)
           .where(team_role: TeamRole.scrum_master.first)
           .exists?
      respond_to do |format|
        format.html { redirect_to project_releases_path(@project), alert: 'You are not the Scrum Master.' }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end

    @release         = Release.new
    @release.project = @project

    @project_form = @project
  end

  def edit
    unless @release
           .project
           .assigned_roles
           .where(thinker: current_thinker)
           .where(team_role: TeamRole.scrum_master.first)
           .exists?
      respond_to do |format|
        format.html { redirect_to project_releases_path(@project), alert: 'You are not the Scrum Master.' }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end

    @project_form = nil
    @project      = @release.project
  end

  def create
    @release          = Release.new(release_params)
    @release.project  = @project
    @release.progress = 0.0

    respond_to do |format|
      if @project
         .assigned_roles
         .where(thinker: current_thinker)
         .where(team_role: TeamRole.scrum_master.first)
         .exists? && @release.save
        create_notification(@release, @project)
        format.html { redirect_to @release, notice: 'Release was successfully created.' }
        format.json { render :show, status: :created, location: @task }
      else
        set_form_errors(@release)
        set_validators_for_form_help

        @project_form = @project

        format.html { render :new }
        format.json { render json: @release.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @release
         .project.assigned_roles
         .where(thinker: current_thinker)
         .where(team_role: TeamRole.scrum_master.first)
         .exists? && @release.update(release_params)
        create_notification(@release, @release.project)
        format.html { redirect_to @release, notice: 'Release was successfully updated.' }
        format.json { render :show, status: :ok, location: @release }
      else
        set_form_errors(@release)
        set_validators_for_form_help

        format.html { render :edit }
        format.json { render json: @release.errors, status: :unprocessable_entity }
      end
    end
  end

  def show
  end

  private

  def set_release
    @release = Release.find(params[:id])
  end

  def set_validators_for_form_help
    description_validators = Release.validators_on(:description)[0]
    @chars_min_description = description_validators.options[:minimum]

    title_validators = Release.validators_on(:title)[0]
    @chars_max_title = title_validators.options[:maximum]
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def release_params
    allowed_params = [:description, :title, :end_at, :version]

    params.require(:release).permit(allowed_params)
  end
end
