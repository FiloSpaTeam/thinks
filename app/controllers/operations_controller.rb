class OperationsController < ApplicationController
  before_action :authenticate_thinker!
  before_action :set_operation, only: [:show, :edit, :update, :destroy, :done]
  before_action :set_task, only: [:index, :new, :create]
  before_action :check_worker!, except: [:index, :destroy]
  before_action :set_project, only: [:index]

  # GET /operations
  # GET /operations.json
  def index
    @operations = @task.operations.order('serial').all

    @workload_voted = @task.votes.where(thinker: current_thinker).first
  end

  # GET /operations/1/edit
  def edit
  end

  # POST /operations
  # POST /operations.json
  def create
    @operation = Operation.new(operation_params)
    @operation.task = @task

    respond_to do |format|
      if @operation.save
        format.html { redirect_to task_operations_path(@task), notice: 'Operation was successfully added.' }
        format.json { render :show, status: :created, location: @operation }
      else
        format.html { render :new }
        format.json { render json: @operation.errors, status: :unprocessable_entity }
      end
    end
  end

  def done
    @operation.done = true
    @task           = @operation.task

    respond_to do |format|
      if @operation.save
        format.html { redirect_to task_operations_path(@task), notice: 'Operation done.' }
        format.json { render :show, status: :created, location: @operation }
      else
        format.html { render :new }
        format.json { render json: @operation.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /operations/1
  # PATCH/PUT /operations/1.json
  def update
    respond_to do |format|
      if @operation.update(operation_params)
        format.html { redirect_to @operation, notice: 'Operation was successfully updated.' }
        format.json { render :show, status: :ok, location: @operation }
      else
        format.html { render :edit }
        format.json { render json: @operation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /operations/1
  # DELETE /operations/1.json
  def destroy
    @task = @operation.task

    respond_to do |format|
      if @task.worker == current_thinker && @operation.destroy
        format.html { redirect_to task_operations_path(@task), notice: 'Operation was successfully destroyed.' }
      else
        format.html { redirect_to task_operations_path(@task), notice: 'You cannot delete operations.' }
      end
    end
  end

  private

  def check_worker!
    redirect_to task_path(@task) unless current_thinker == @task.worker
  end

  def set_task
    @task = Task.find(params[:task_id])
  end

  def set_project
    @project = @task.project
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_operation
    @operation = Operation.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def operation_params
    params.require(:operation).permit(:text)
  end
end
