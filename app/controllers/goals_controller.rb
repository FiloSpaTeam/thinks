# frozen_string_literal: true

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

# Copyright (c) 2015,2018 Claudio Maradonna

# Handles goals of the project
class GoalsController < ApplicationController
  include ActionView::Helpers::TextHelper
  include StatusesHelper
  include GoalsHelper
  include ApplicationHelper
  include SmartListing::Helper::ControllerExtensions
  helper  SmartListing::Helper

  before_action :authenticate_thinker!

  before_action :set_project
  before_action :set_goal, only: %i[show edit update destroy tasks_in_sprint]

  before_action :check_ban!, except: %i[index]
  before_action :check_scrum_master!, only: %i[new edit create
                                               update tasks_in_sprint]

  before_action :set_validators_for_form_help, only: %i[new edit]

  before_action :share_statuses, only: %i[show edit tasks_in_sprint]

  # GET /goals
  # GET /goals.json
  def index
    goals_scope = Goal
                  .includes(:tasks, :project)
                  .where(project: @project)
                  .order('progress DESC')
                  .order('created_at DESC')

    params[:filters].delete Enums::FiltersNames::DELETED_AT if
      params[:filters].present? &&
      params[:filters].key?(Enums::FiltersNames::DELETED_AT) &&
      params[:filters][Enums::FiltersNames::DELETED_AT] == '0'

    goals_scope = apply_filters(goals_scope, params[:filters]) if
      params[:filters].present?

    smart_listing_create :goals,
                         goals_scope,
                         partial: 'goals/list',
                         default_sort: { id: 'desc' }

    @active_filters = [
      Enums::Filters::SEARCH_INPUT,
      Enums::Filters::SEARCH_TASK,
      Enums::Filters::PROGRESS_LOWER_THAN,
      Enums::Filters::CLOSED
    ]

    @breadcrumbs = {
      "project_goals_path('#{@project.slug}')" => I18n.t('breadcrumbs.project_goals_path')
    }

    @search = ''
    if params.key?(:filters) &&
       params[:filters].key?(:search_title_and_description)
      @search = params[:filters][:search_title_and_description].strip
    end
  end

  # GET /goals/1
  # GET /goals/1.json
  def show
    @breadcrumbs = {
      "project_goals_path('#{@project.slug}')" => I18n.t('breadcrumbs.project_goals_path'),
      "project_goal_path(@project, #{@goal.id})"                 => @goal.title
    }

    @page_description = middle_dot + " <i>#{@goal.title}</i>".html_safe
  end

  # GET /goals/new
  def new
    @goal         = Goal.new
    @project_form = @project
    @project_releases = @project.releases.order('version')

    @breadcrumbs = {
      "project_goals_path('#{@project.slug}')" => I18n.t('breadcrumbs.project_goals_path'),
      'nil' => I18n.t('new')
    }
  end

  # GET /goals/1/edit
  def edit
    @project_form = nil
    @project_releases = @project.releases.order('version')

    @breadcrumbs = {
      "project_goals_path('#{@project.slug}')" => I18n.t('breadcrumbs.project_goals_path'),
      "project_goal_path(@project, #{@goal.id})" => @goal.title,
      'nil' => I18n.t('edit')
    }

    @page_description = "\"<i>#{@goal.title}</i>\""
  end

  # POST /goals
  # POST /goals.json
  def create
    respond_to do |format|
      @goal          = Goal.new(goal_params)
      @goal.project  = @project
      @goal.thinker  = current_thinker
      @goal.progress = 0.0

      if @goal.save
        create_notification(@goal, @goal.project)
        puts @goal.errors.full_messages
        format.html { redirect_to project_goal_path(@project, @goal), notice: t('alerts.created', subject: t('goals.goal'), title: @goal.title) }
        format.json { render :show, status: :created, location: @goal }
      else
        set_form_errors(@goal)
        set_validators_for_form_help

        @project_form = @project
        @project_releases = @project.releases.order('version')

        format.html { render :new }
        format.json { render json: @goal.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /goals/1
  # PATCH/PUT /goals/1.json
  def update
    respond_to do |format|
      if @goal.update(goal_params)
        create_notification(@goal, @goal.project)
        format.html { redirect_to project_goal_path(@project, @goal), notice: t('alerts.updated', subject: t('goals.goal'), title: @goal.title) }
        format.json { render :show, status: :ok, location: @goal }
      else
        set_form_errors(@goal)
        set_validators_for_form_help

        @project_releases = @project.releases.order('version')

        format.html { render :edit }
        format.json { render json: @goal.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /goals/1
  # DELETE /goals/1.json
  def destroy
    respond_to do |format|
      notice = if @goal.deleted?
                 t('alerts.deleted', subject: t('goals.goal'), title: @goal.title)
               else
                 t('alerts.discarded', subject: t('goals.goal'), title: @goal.title)
               end

      @goal.destroy

      create_notification(@goal, @goal.project)
      format.html { redirect_to project_goals_path(@goal.project), notice: notice }
      format.json { head :no_content }
    end
  end

  def tasks_in_sprint
    tasks_ready      = @goal.tasks.ready_to_sprint
    n_of_tasks_ready = tasks_ready.count

    respond_to do |format|
      unless n_of_tasks_ready.positive?
        format.html { redirect_to project_goal_path(@project, @goal), alert: "No task can be put in Sprint! Check out some and analize with your team!" }
      end

      tasks_ready.update_all(status_id: @statuses.sprint.first)

      create_notification(@goal, @goal.project)

      format.html { redirect_to project_goals_path(@goal.project), notice: pluralize(n_of_tasks_ready, "task") + ' was successfully get in sprint!' }
      format.json { head :no_content }
    end
  end

  private

  def set_validators_for_form_help
    title_validators = Goal.validators_on(:title)[0]
    @chars_max_title = title_validators.options[:maximum]

    title_validators = Goal.validators_on(:description)[0]
    @chars_min_description = title_validators.options[:minimum]
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_goal
    @goal = Goal
            .includes(:project, :thinker, :tasks)
            .with_deleted
            .friendly
            .find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def goal_params
    params[:goal].permit(:title, :description, :release_id)
  end
end
