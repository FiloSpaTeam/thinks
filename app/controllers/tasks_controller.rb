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

class TasksController < ApplicationController
  include ProjectsHelper
  include StatusesHelper
  include TasksHelper
  include SmartListing::Helper::ControllerExtensions
  helper  SmartListing::Helper

  before_action :authenticate_thinker!

  before_action :set_task, only: [:show, :edit, :update, :destroy, :progress, :assign, :judge, :sprint, :release, :reopen, :give_up]
  before_action :set_project, only: [:new, :index, :create]

  # before_action :check_ban!, except: [:index]

  before_action :set_validators_for_form_help, only: [:new, :edit]
  before_action :set_validators_for_show, only: [:show]

  before_action :teammate!, only: [:new, :create]
  before_action :check_assign!, only: [:assign]

  before_action :share_statuses, only: [:index, :destroy, :sprint, :assign, :give_up, :release]

  impressionist actions: [:show],
                unique: [:impressionable_id, :user_id]

  # GET /projects/1/tasks
  # GET /projects/1/tasks.json
  def index
    tasks_scope = Task
                  .includes(:status, :thinker, :updater, :goal, :children)
                  .where(project: @project)
    tasks_scope = apply_filters(tasks_scope, params[:filters]) if params[:filters].present?
    tasks_scope = apply_sorter(tasks_scope, params[:tasks_smart_listing][:sort]) if params.key?(:tasks_smart_listing) &&
                                                                                    params[:tasks_smart_listing].key?(:sort)


    smart_listing_create :tasks,
                         tasks_scope,
                         partial: 'tasks/list',
                         default_sort: { serial: 'desc' }

    @active_filters = [
      Enums::Filters::SEARCH_RELEASE,
      Enums::Filters::SEARCH_GOAL,
      Enums::Filters::SEARCH_WORKER,
      Enums::Filters::SEARCH_THINKER,
      Enums::Filters::CLOSED_TASKS
    ]

    @search = ''
    if params.key?(:filters) &&
       params[:filters].key?(:search_title_and_description)
      @search = params[:filters][:search_title_and_description].strip
    end
  end

  # GET /tasks/1
  # GET /tasks/1.json
  def show
    @comments         = @task
                        .comments(include: [:likes, :thinker, :reason])
                        .with_deleted
                        .order(likes_count: :desc, created_at: :desc)
    @comment_approved = @comments.approved.first
    @reason           = @comment_approved.try(:reason) || Reason.new
    @workload_voted   = @task.votes.where(thinker: current_thinker).first

    @project = @task.project
    @comment = Comment.new
  end

  # GET /projects/1/tasks/new
  def new
    @task         = Task.new
    @task.project = @project

    @project_form = @project
  end

  # GET /tasks/1/edit
  def edit
    @project_form = nil
    @project      = @task.project

    if current_thinker != @task.thinker && !scrum_master?(@task.project)
      respond_to do |format|
        format.html { redirect_to @task, alert: 'You cannot edit this.' }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # POST /projects/1/tasks
  # POST /projects/1/tasks.json
  def create
    @task = Task.new(task_params)

    @task.release = nil unless scrum_master?(@project)

    @task.project = @project
    @task.thinker = current_thinker
    @task.updater = current_thinker

    respond_to do |format|
      if @task.save
        create_notification(@task, @project)
        format.html { redirect_to @task, notice: 'Task was successfully created.' }
        format.json { render :show, status: :created, location: @task }
      else
        set_form_errors(@task)
        set_validators_for_form_help

        @project_form = @project

        format.html { render :new }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tasks/1
  # PATCH/PUT /tasks/1.json
  def update
    @task.updater = current_thinker

    respond_to do |format|
      if (current_thinker == @task.thinker ||
          scrum_master?(@task.project)) &&
          @task.update(task_params)
        create_notification(@task, @task.project)

        format.html { redirect_to @task, notice: 'Task was successfully updated.' }
        format.json { render :show, status: :ok, location: @task }
      else
        @project = @task.project
        set_validators_for_form_help

        format.html { render :edit }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tasks/1
  # DELETE /tasks/1.json
  def destroy
    respond_to do |format|
      if current_thinker == @task.thinker || scrum_master?(@task.project)
        if @task.deleted?
          @task.really_destroy!

          format.html { redirect_to project_tasks_url(@task.project), notice: 'Task was successfully deleted.' }
        else
          if params[:reason][:text].nil?
            format.html { redirect_to @task, alert: 'You need to specify a reason.' }
          else
            @task.destroy_and_associate_reason(params.require(:reason), current_thinker)
            create_notification(@task, @task.project)

            format.html { redirect_to @task, notice: 'Task was successfully closed.' }
          end
        end

        format.json { head :no_content }
      else
        format.html { redirect_to @task, alert: 'You cannot destroy this task!' }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tasks/1/judge
  # PATCH/PUT /tasks/1/judge.json
  def sprint
    respond_to do |format|
      if scrum_master?(@task.project)
        if @task.project.suspended
          format.html { redirect_to task_path(@task), alert: 'Currently the development is suspended.' }
          format.json { render json: {}, status: :unprocessable_entity }
        else
          @task.status = @statuses.sprint.first

          if @task.save
            create_notification(@task, @task.project)
            format.html { redirect_to @task, notice: 'Task ready for this sprint! Good job!' }
            format.json { render :show, status: :ok, location: @task }
          else
            format.html { render :edit }
            format.json { render json: @task.errors, status: :unprocessable_entity }
          end
        end
      else
        format.html { redirect_to task_path(@task), alert: t('you_are_not_the_scrum_master') }
        format.json { render json: {}, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tasks/1/judge
  # PATCH/PUT /tasks/1/judge.json
  def release
    respond_to do |format|
      if scrum_master?(@task.project)
        if @task.project.suspended
          format.html { redirect_to task_path(@task), alert: 'Currently the development is suspended.' }
          format.json { render json: {}, status: :unprocessable_entity }
        else
          @task.status = @statuses.release.first
          @task.worker = nil
          @task.end_at = nil

          if @task.save
            create_notification(@task, @task.project)
            format.html { redirect_to @task, notice: 'Task is ready for next Sprint!' }
            format.json { render :show, status: :ok, location: @task }
          else
            format.html { render :edit }
            format.json { render json: @task.errors, status: :unprocessable_entity }
          end
        end
      else
        format.html { redirect_to task_path(@task), alert: t('you_are_not_the_scrum_master') }
        format.json { render json: {}, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tasks/1/judge
  # PATCH/PUT /tasks/1/judge.json
  def judge
    workload = Workload.find(task_params[:workload])

    @vote = Vote.new

    @vote.thinker  = current_thinker
    @vote.task     = @task
    @vote.workload = workload

    respond_to do |format|
      if @vote.save
        format.html { redirect_to @task, notice: 'Your thinks is part of the workload now!' }
        format.json { render :show, status: :ok, location: @task }
      else
        format.html { render :edit }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tasks/1/assign
  # PATCH/PUT /tasks/1/assign.json
  def assign
    @task.worker = current_thinker
    @task.status = @statuses.in_progress.first
    respond_to do |format|
      if @task.save
        create_notification(@task, @task.project)
        format.html { redirect_to @task, notice: 'You have a new task to do! Good job!' }
        format.json { render :show, status: :ok, location: @task }
      else
        format.html { render :show }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  def reopen
    @task.restore(recursive: true)
    create_notification(@task, @task.project)
    respond_to do |format|
      format.html { redirect_to @task, notice: 'You restored the task. Good job!' }
      format.json { render :show, status: :ok, location: @task }
    end
  end

  def give_up
    @task.worker = nil
    @task.status = @statuses.sprint.first
    @task.save

    create_notification(@task, @task.project)
    respond_to do |format|
      format.html { redirect_to @task, notice: 'You give up work. Good job!' }
      format.json { render :show, status: :ok, location: @task }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_task
    @task = Task
            .includes(:comments, :votes, :worker, :thinker, :project, :ratings)
            .with_deleted.find(params[:id])
  end

  def set_validators_for_form_help
    description_validators = Task.validators_on(:description)[0]
    @chars_min_description = description_validators.options[:minimum]

    title_validators = Task.validators_on(:title)[0]
    @chars_max_title = title_validators.options[:maximum]
  end

  def set_validators_for_show
    comment_validators = Comment.validators_on(:text)[0]
    @chars_max_comment = comment_validators.options[:maximum]
  end

  def teammate!
    unless @project.part_of_team?(current_thinker)
      flash[:alert] = 'You are not partecipating to this project as active member!'
      redirect_to project_tasks_path(@project)
    end
  end

  def check_assign!
    if current_thinker.working_tasks.in_progress.present?
      flash[:alert] = 'You have already something to do :P'
      redirect_to task_path(@task)
    end
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def task_params
    allowed_params = [:description, :status_id, :workload, :title, :goal_id, :release_id, :father_id]

    params.require(:task).permit(allowed_params)
  end
end
