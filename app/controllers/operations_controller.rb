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

class OperationsController < ApplicationController
  before_action :authenticate_thinker!

  before_action :set_project
  before_action :set_task
  before_action :set_operation, only: [:show, :edit, :update, :destroy, :done]
  before_action :check_worker!, except: [:index, :destroy, :done]
  before_action :set_project, only: [:index]

  # GET /operations
  # GET /operations.json
  def index
    @operations = @task
                  .operations
                  .with_deleted
                  .order('serial')
                  .all

    @workload_voted = @task
                      .votes
                      .with_deleted
                      .where(thinker: current_thinker)
                      .first

    @breadcrumbs = {
      "project_tasks_path('#{@task.project.slug}')" => I18n.t('breadcrumbs.project_tasks_path'),
      "task_path(#{@task.id})"                 => "\##{@task.serial} <span class='hidden-xs'>#{@task.title}</span>",
      'nil' => I18n.t('operations_t')
    }
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
        create_notification(@operation, @operation.task.project)
        format.html { redirect_to project_task_path(@project, @task), notice: 'Operation was successfully added.' }
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
      if @task.worker == current_thinker && @operation.save
        create_notification(@operation, @operation.task.project)
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
        create_notification(@operation, @operation.task.project)
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
      if @task.worker == current_thinker && @operation.destroy_and_update_serial
        destroy_notification(@operation, @operation.task.project)
        format.html { redirect_to project_task_path(@project, @task), notice: 'Operation was successfully destroyed.' }
      else
        format.html { redirect_to project_task_path(@project, @task), alert: 'You cannot delete operations.' }
      end
    end
  end

  private

  def check_worker!
    redirect_to task_path(@task) unless current_thinker == @task.worker
  end

  def set_task
    @task = Task.with_deleted.friendly.find(params[:task_id])
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
