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

class ProjectsController < ApplicationController
  include ProjectsHelper
  include SmartListing::Helper::ControllerExtensions
  helper  SmartListing::Helper

  before_action :authenticate_thinker!, except: [:index, :show]
  before_action :set_project, only: [:show, :edit, :update, :destroy, :contribute, :tasks, :elect, :suspend, :resume, :brief]
  before_action :set_contribution, only: [:show]
  before_action :thinker!, only: [:edit, :update, :destroy]

  def index
    @minimum_good_number_of_projects = 10
    @projects_count = Project.count
    if @projects_count > @minimum_good_number_of_projects
      @most_popular = Project.limit(6)

      @categories = Category.order(:t_name).limit(10)
    else
      redirect_to start_index_url
    end
  end

  # GET /projects
  # GET /projects.json
  def index_2
    projects_scope = Project
                     .includes(:category, :thinker)
                     .where('projects.project_id is NULL')
                     .where('visible IS TRUE')

    if params[:filters].present?
      projects_scope = apply_filters(projects_scope, params[:filters])

      @five_random_projects = Project.order('RANDOM()').limit(5) if projects_scope.empty?
    end

    smart_listing_create :projects,
                         projects_scope,
                         partial: 'projects/list',
                         default_sort: { impressions_count: 'desc' },
                         sort_attributes: [
                           [:impressions_count, 'impressions_count'],
                           [:title, 'title'],
                           [:category_name, 'categories.t_name'],
                           [:thinker_name, 'thinkers.name']
                         ],
                         page_sizes: [9]

    # @most_active_projects = Project
    #                         .order(impressions_count: :desc)
    #                         .limit(5)

    # @most_followed_projects = Project
    #                           .joins(:contributions)
    #                           .group('projects.id')
    #                           .order('COUNT(contributions) desc')
    #                           .limit(5)

    # @recent_projects = Project
    #                    .order(created_at: :desc)
    #                    .limit(5)

    @project_thinkers = Thinker.all
    @categories       = Category.all
  end

  # GET /projects/1
  # GET /projects/1.json
  def show
    impressionist(@project, '', unique: [:impressionable_id, :user_id])
  end

  # GET /projects/new
  def new
    @project = Project.new

    @project.description = "*Put here your short description, will be used for index your project* \n\nDescribe your project, and remember, you can use MARKDOWN!"
  end

  # GET /projects/1/edit
  def edit
  end

  # POST /projects
  # POST /projects.json
  def create
    @project = Project.new(project_params)
    @project.thinker = current_thinker

    respond_to do |format|
      if @project.save
        @project.save_first_team_roles

        format.html { redirect_to @project, notice: 'Project was successfully created.' }
        format.json { render :show, status: :created, location: @project }
      else
        set_form_errors(@project)
        format.html { render :new }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /projects/1
  # PATCH/PUT /projects/1.json
  def update
    respond_to do |format|
      if @project.started?
        if @project.release_at != project_params[:release_at]
          format.html { redirect_to project_path(@project), error: t(:cant_update_release_at) }
          format.json { render json: @project.errors, status: :cant_update_release_at }
        end
      end

      if @project.update(project_params)
        create_notification(@project, @project)
        format.html { redirect_to project_path(@project), notice: 'Project was successfully updated.' }
        format.json { render :show, status: :ok, location: @project }
      else
        set_form_errors(@project)

        format.html { render :edit }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.json
  def destroy
    respond_to do |format|
      @project.destroy
      create_notification(@project, @project)
      format.html { redirect_to projects_url, notice: 'Project was successfully closed.' }
      format.json { head :no_content }
    end
  end

  # PATCH/PUT /projects/1/contribute
  # PATCH/PUT /projects/1/contribute.json
  def contribute
    respond_to do |format|
      @contribution           = Contribution.where(thinker: current_thinker)
                                            .where(project: @project)
                                            .first_or_create
      @contribution.intensity = params[:contribution][:intensity]
      @contribution.save_and_update_team_role

      create_notification(@project, @project)
      format.html { redirect_to project_path(@project), notice: 'Your contribution has been saved!' }
    end
  end

  # GET /projects/1/tasks
  # GET /projects/1/tasks.json
  # def tasks
  #   @statuses = Status.all
  #   @tasks    = @project.tasks
  # end

  def elect
    respond_to do |format|
      @voter = Voter
               .new(
                 params
                 .require(:voter)
                 .permit(:election_poll_id, :elect_id)
               )

      if Voter
         .where(thinker: current_thinker)
         .where(election_poll: @voter.election_poll)
         .exists?
        format.html { redirect_to project_teams_path(@project), alert: 'You cannot vote twice!' }
        format.json { render json: {}, status: :unprocessable_entity }
      elsif !@project.part_of_team?(current_thinker)
        format.html { redirect_to project_teams_path(@project), alert: 'You cannot vote!' }
        format.json { render json: {}, status: :unprocessable_entity }
      else
        @voter.thinker = current_thinker
        @voter.save

        format.html { redirect_to project_teams_path(@project), notice: 'Thanks for your vote!' }
        format.json { head :no_content }
      end
    end
  end

  def suspend
    respond_to do |format|
      if !scrum_master?(@project)
        format.html { redirect_to @project, alert: 'You cannot suspend the project.' }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      else
        @project.suspend(true)

        format.html { redirect_to @project, notice: "The project was suspended. You can resume the development at any time." }
        format.json { head :no_content }
      end
    end
  end

  def resume
    respond_to do |format|
      if !scrum_master?(@project)
        format.html { redirect_to @project, alert: 'You cannot resume the project.' }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      else
        @project.suspend(false)

        format.html { redirect_to @project, notice: 'The development is resumed. Good job!' }
        format.json { head :no_content }
      end
    end
  end

  def brief
    @releases = @project.releases.includes(:goals).where('progress < 100').order(:end_at)
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_contribution
    @contribution = Contribution
                    .where(thinker: current_thinker)
                    .where(project: @project)
                    .first_or_initialize
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def project_params
    params
      .require(:project)
      .permit(
        :title, :motto, :description, :contribution_text,
        :release_at, :license_id, :source_code_url,
        :home_url, :documentation_url,
        :cycle_id, :category_id, :main_image, :logo
      )
  end
end
