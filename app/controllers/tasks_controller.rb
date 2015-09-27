class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy, :progress, :assign]
  before_action :set_project, only: [:new, :index, :create]
  before_action :set_validators_for_form_help, only: [:new, :edit]

  # GET /projects/1/tasks
  # GET /projects/1/tasks.json
  def index
    @tasks    = Task.where(project: @project)
    @statuses = Status.unscoped.for_print
  end

  # GET /tasks/1
  # GET /tasks/1.json
  def show
    @status_sprint      = Status.sprint.first
    @status_release     = Status.release.first
    @status_in_progress = Status.in_progress.first
  end

  # GET /projects/1/tasks/new
  def new
    @task = Task.new
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

  # PATCH/PUT /tasks/1/progress
  # PATCH/PUT /tasks/1/progress.json
  def progress
    respond_to do |format|
      if @task.progress && @task.save
        format.html { redirect_to @task, notice: 'Task is scheduled in release' }
        format.json { render :show, status: :ok, location: @task }
      else
        flash.now[:error] = "Maybe workload is too high to allow progress task in Sprint. Make team get better decision over them."
        format.html { render :show, notice: "Error" }
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
      @project = Project.find(params[:project_id])
    end

    def set_validators_for_form_help
      description_validators = Task.validators_on(:description)[0]
      @chars_min = description_validators.options[:minimum]
      @chars_max = description_validators.options[:maximum]
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def task_params
      allowed_params = [:serial, :description, :project_id, :task_id, :thinker_id, :worker_thinker_id, :status_id, :workload_id]

      params.require(:task).permit(allowed_params)
    end
end
