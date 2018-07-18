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

class RecruitmentsController < ApplicationController
  include ProjectsHelper
  include TasksHelper
  include SmartListing::Helper::ControllerExtensions
  helper  SmartListing::Helper

  impressionist actions: [:index]

  before_action :authenticate_thinker!

  before_action :set_task, only: [:show, :edit, :update, :destroy, :approve, :reopen]
  before_action :set_project, only: [:new, :index, :create]
  before_action :set_validators_for_show, only: [:show]

  before_action :check_ban!
  before_action :check_contribution_type!, only: [:new, :index, :create]
  before_action :check_demand!, only: [:new]
  before_action :check_task!, only: [:show]
  before_action :readonly_demand!, only: [:edit, :update]

  before_action :set_validators_for_form_help, only: [:new]

  def index
    rtasks_scope = Task
                   .with_deleted
                   .includes(:thinker, :updater, :status)
                   .where(project: @project)
                   .where(recruitment: true)
    rtasks_scope = apply_filters(rtasks_scope.without_deleted, params[:filters]) if params[:filters].present?

    @statuses = Status.where(translation_code: [:backlog, :done])

    smart_listing_create :recruitments,
                         rtasks_scope,
                         partial: 'recruitments/list',
                         default_sort: { status_id: 'desc' }

    @breadcrumbs = {
      "project_recruitments_path('#{@project.slug}')" => I18n.t('breadcrumbs.project_recruitments_path')
    }

    @active_filters = [Enums::Filters::SEARCH_INPUT]

    @recruitment_manifest_seen = Impression
                                 .where(controller_name: 'recruitments')
                                 .where(user_id: current_thinker)
                                 .where(action_name: :index)
                                 .count

    @search = ''
    if params.key?(:filters) &&
       params[:filters].key?(:search_title_and_description)
      @search = params[:filters][:search_title_and_description].strip
    end
  end

  # GET /recruitments/1
  # GET /recruitments/1.json
  def show
    @comments         = Comment
                        .unscoped
                        .includes(:thinker, :reason)
                        .where(task: @task)
                        .with_deleted
                        .order(approved: :desc, created_at: :desc)
    @reason           = @comment_approved.try(:reason) || Reason.new
    @workload_voted   = @task.votes.where(thinker: current_thinker).first

    @project = @task.project
    @comment = Comment.new

    impressionist(@task, '', unique: [:impressionable_id, :user_id])

    @breadcrumbs = {
      "project_recruitments_path('#{@project.slug}')" => I18n.t('breadcrumbs.project_recruitments_path'),
      "recruitment_path(#{@task.id})"                 => "\##{@task.serial} <span class='hidden-xs'>#{@task.title}</span>"
    }
  end

  def new
    @task         = Task.new
    @task.project = @project

    @breadcrumbs = {
      "project_recruitments_path('#{@project.slug}')" => I18n.t('breadcrumbs.project_recruitments_path'),
      'nil' => I18n.t('new')
    }
  end

  # POST /projects/1/recruitments
  # POST /projects/1/recruitments.json
  def create
    @task = Task.new(recruitment_params)

    @task.recruitment = true

    @task.project = @project
    @task.thinker = current_thinker
    @task.updater = current_thinker

    respond_to do |format|
      if @task.save
        create_notification(@task, @project)
        format.html { redirect_to recruitment_path(@task), notice: 'Your demand was successfully sent.' }
        format.json { render :show, status: :created, location: @task }
      else
        set_form_errors(@task)
        set_validators_for_form_help

        format.html { render :new }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
  end

  def update
  end

  def destroy
    respond_to do |format|
      if @scrum_master
        if @task.deleted?
          format.html { redirect_to project_tasks_url(@task.project), alert: 'Demand already rejected!' }
        else
          if params[:reason][:text].nil?
            format.html { redirect_to project_task_path(@project, @task), alert: 'You need to specify a reason.' }
          else
            @task.destroy_and_associate_reason(params.require(:reason), current_thinker)
            create_notification(@task, @task.project)

            format.html { redirect_to recruitment_path(@task), notice: 'Demand successfully rejected.' }
          end
        end

        format.json { head :no_content }
      else
        format.html { redirect_to recruitment_path(@task), alert: 'Operation not allowed.' }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  def approve
    respond_to do |format|
      if @scrum_master
        @task.status = Status.done.first
        @task.save

        create_notification(@task, @task.project)

        format.html { redirect_to recruitment_path(@task), notice: 'Demand successfully approved.' }
      else
        format.html { redirect_to recruitment_path(@task), alert: 'Operation not allowed.' }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  def reopen
    @task.restore(recursive: true)
    create_notification(@task, @task.project)
    respond_to do |format|
      format.html { redirect_to project_task_path(@project, @task), notice: 'Now demand has another chance.' }
      format.json { render :show, status: :ok, location: @task }
    end
  end

  private

  def set_task
    @task = Task
            .includes(:comments, :thinker, :project)
            .with_deleted
            .find(params[:id])
  end

  def set_validators_for_show
    comment_validators = Comment.validators_on(:text)[0]
    @chars_max_comment = comment_validators.options[:maximum]
  end

  def check_demand!
    if @project.recruitment_demand?(current_thinker)
      flash[:error] = 'You already made a recruitment demand!'

      redirect_to project_recruitments_path(@project)
    end
  end

  def check_task!
    redirect_to task_path(@task) unless @task.recruitment
  end

  def readonly_demand!
    flash[:error] = 'You cannot edit your demand!'

    redirect_to project_recruitments_path(@task.project)
  end

  def check_contribution_type!
    if @project.open?
      flash[:error] = "You don't need recruitment, project is open. Enjoy!"

      redirect_to project_path(@project)
    end
  end

  def set_validators_for_form_help
    description_validators = Task.validators_on(:description)[0]
    @chars_min_description = description_validators.options[:minimum]

    title_validators = Task.validators_on(:title)[0]
    @chars_max_title = title_validators.options[:maximum]
  end

  def recruitment_params
    allowed_params = [:title, :description]

    params.require(:task).permit(allowed_params)
  end
end
