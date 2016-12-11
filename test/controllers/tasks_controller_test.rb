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

require 'test_helper'

class TasksControllerTest < ActionController::TestCase
  setup do
    @task = tasks(:task_one)

    authenticate
  end

  test 'should get index' do
    get :index, project_id: @task.project_id
    assert_response :success
  end

  test 'should get new' do
    get :new, project_id: @task.project_id
    assert_response :success
  end

  test 'should create task' do
    assert_difference('Task.count') do
      post :create, project_id: @task.project_id, task: { title: @task.title, description: @task.description, project_id: @task.project_id, thinker_id: @task.thinker_id, status_id: @task.status_id }
    end

    assert_redirected_to task_path(assigns(:task))
  end

  test 'should show task' do
    get :show, id: @task
    assert_response :success
  end

  test 'should get edit' do
    get :edit, id: @task
    assert_response :success
  end

  test 'should update task' do
    patch :update, id: @task, task: { description: @task.description, project_id: @task.project_id, serial: @task.serial, status_id: @task.status_id, thinker_id: @task.thinker_id, worker_thinker_id: @task.worker_thinker_id }
    assert_redirected_to task_path(assigns(:task))
  end

  # test 'should destroy task' do
  #   assert_difference('Task.count', -1) do
  #     delete :destroy, id: @task
  #   end

  #   assert_redirected_to project_tasks_path(@task.project_id)
  # end
end
