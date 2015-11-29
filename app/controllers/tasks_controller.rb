class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy, :progress, :assign, :judge, :sprint]
  before_action :set_project, only: [:new, :index, :create]
  before_action :set_validators_for_form_help, only: [:new, :edit]
  before_action :set_validators_for_show, only: [:show]

  # GET /projects/1/tasks
  # GET /projects/1/tasks.json
  def index
    @filterrific = initialize_filterrific(
      Task.where(:project => @project),
      params[:filterrific],
      select_options: {
        sorted_by_title: Task.options_for_sorted_by(:title),
        sorted_by_workload: Task.options_for_sorted_by(:workload)
      }
    ) or return
    if params.has_key?(:filterrific) && params[:filterrific].has_key?("current_thinker")
      @tasks    = @filterrific.find.with_current_thinker(current_thinker).page params[:page]
    else
      @tasks    = @filterrific.find.page params[:page]
    end
    @statuses = Status.all
  rescue ActiveRecord::RecordNotFound => e
    # There is an issue with the persisted param_set. Reset it.
    puts "Had to reset filterrific params: #{ e.message }"
    redirect_to(reset_filterrific_url(format: :html)) and return
  end

  # GET /tasks/1
  # GET /tasks/1.json
  def show
    @status_sprint      = Status.sprint.first
    @status_release     = Status.release.first
    @status_in_progress = Status.in_progress.first

    @workloads = Workload.all

    @comments = @task.comments(:include => :likes)
    @likes    = @task.likes
    @comment  = Comment.new
    @workload = Workload.new

    if @task.status == Status.done.first
      @comment_approved = @comments.approved.first
      @reason           = @comment_approved.reason || Reason.new
    end

    @workload_voted = @task.votes.where(thinker: current_thinker).first

    @liked   = @task.liked?(current_thinker)
  end

  # GET /projects/1/tasks/new
  def new
    @task         = Task.new
    @task.project = @project
  end

  # GET /tasks/1/edit
  def edit
  end

  # POST /projects/1/tasks
  # POST /projects/1/tasks.json
  def create
    @task         = Task.new(task_params)
    @task.project = @project
    @task.thinker = current_thinker

    respond_to do |format|
      if @task.save
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
    respond_to do |format|
      if @task.update(task_params)
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
    @task.destroy
    respond_to do |format|
      format.html { redirect_to tasks_url, notice: 'Task was successfully destroyed.' }
      format.json { head :no_content }
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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_task
      @task = Task.find(params[:id])
    end

    def set_project
      @project = Project.friendly.find(params[:project_id])
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

    # Never trust parameters from the scary internet, only allow the white list through.
    def task_params
      allowed_params = [:description, :status_id, :workload, :title, :goal_id]

      params.require(:task).permit(allowed_params)
    end
end
