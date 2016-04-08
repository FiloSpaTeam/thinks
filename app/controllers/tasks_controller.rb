class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy, :progress, :assign, :judge, :sprint, :release, :reopen]
  before_action :set_project, only: [:new, :index, :create]
  before_action :set_validators_for_form_help, only: [:new, :edit]
  before_action :set_validators_for_show, only: [:show]

  before_action :authenticate_thinker!
  before_action :teammate!, only: [:new, :create]
  before_action :check_assign!, only: [:assign]

  # GET /projects/1/tasks
  # GET /projects/1/tasks.json
  def index
    @filterrific = initialize_filterrific(
      Task,
      params[:filterrific],
      select_options: {
        sorted_by_title: Task.options_for_sorted_by(:title),
        sorted_by_workload: Task.options_for_sorted_by(:workload)
      }
    ) || return
    @tasks    = @filterrific.find.where(project: @project).page params[:page]
    @statuses = Status.all
  rescue ActiveRecord::RecordNotFound => e
    # There is an issue with the persisted param_set. Reset it.
    puts "Had to reset filterrific params: #{e.message}"
    redirect_to(reset_filterrific_url(format: :html)) && return
  end

  # GET /tasks/1
  # GET /tasks/1.json
  def show
    @comments = @task.comments(:include => :likes)
    if @task.status == Status.done.first
      @comment_approved = @comments.approved.first
      @reason           = @comment_approved.reason || Reason.new
    end
    @workload_voted = @task.votes.where(thinker: current_thinker).first

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

    if current_thinker != @task.thinker
      respond_to do |format|
        format.html { redirect_to @task, alert: "You cannot edit this." }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # POST /projects/1/tasks
  # POST /projects/1/tasks.json
  def create
    @task         = Task.new(task_params)
    @task.project = @project
    @task.thinker = current_thinker

    respond_to do |format|
      if @task.save && create_notification(@task)
        format.html { redirect_to @task, notice: 'Task was successfully created.' }
        format.json { render :show, status: :created, location: @task }
      else
        set_form_errors(@task)
        set_validators_for_form_help

        format.html { render :new }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tasks/1
  # PATCH/PUT /tasks/1.json
  def update
    @project = @task.project

    respond_to do |format|
      if current_thinker == @task.thinker && @task.update(task_params) && create_notification(@task)
        format.html { redirect_to @task, notice: 'Task was successfully updated.' }
        format.json { render :show, status: :ok, location: @task }
      else
        format.html { render :edit }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tasks/1
  # DELETE /tasks/1.json
  def destroy
    respond_to do |format|
      if current_thinker == @task.thinker
        @task.destroy

        @project = @task.project
        create_notification(@task)

        format.html { redirect_to project_tasks_url(@task.project), notice: 'Task was successfully closed.' }
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
    @task.status = Status.sprint.first

    respond_to do |format|
      if @task.save
        format.html { redirect_to @task, notice: 'Your thinks is part of the workload now!' }
        format.json { render :show, status: :ok, location: @task }
      else
        format.html { render :edit }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tasks/1/judge
  # PATCH/PUT /tasks/1/judge.json
  def release
    @task.status = Status.release.first

    respond_to do |format|
      if @task.save
        format.html { redirect_to @task, notice: 'Your thinks is ready for next Sprint!' }
        format.json { render :show, status: :ok, location: @task }
      else
        format.html { render :edit }
        format.json { render json: @task.errors, status: :unprocessable_entity }
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
    @task.status = Status.in_progress.first
    respond_to do |format|
      if @task.save
        format.html { redirect_to @task, notice: 'You have a new task to do! Good job!' }
        format.json { render :show, status: :ok, location: @task }
      else
        format.html { render :show }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  def reopen
    @task.restore
    respond_to do |format|
      format.html { redirect_to @task, notice: 'You restored the task. Good job!' }
      format.json { render :show, status: :ok, location: @task }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_task
    @task = Task.with_deleted.find(params[:id])
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
    if !@project.part_of_team?(current_thinker)
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
    allowed_params = [:description, :status_id, :workload, :title, :goal_id]

    params.require(:task).permit(allowed_params)
  end
end
