require 'test_helper'

class TasksControllerTest < ActionController::TestCase
  setup do
    @task = tasks(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:tasks)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create task" do
    assert_difference('Task.count') do
      post :create, task: { description: @task.description, project_id: @task.project_id, serial: @task.serial, status_id: @task.status_id, task_id: @task.task_id, thinker_id: @task.thinker_id, worker_thinker_id: @task.worker_thinker_id, workload_id: @task.workload_id }
    end

    assert_redirected_to task_path(assigns(:task))
  end

  test "should show task" do
    get :show, id: @task
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @task
    assert_response :success
  end

  test "should update task" do
    patch :update, id: @task, task: { description: @task.description, project_id: @task.project_id, serial: @task.serial, status_id: @task.status_id, task_id: @task.task_id, thinker_id: @task.thinker_id, worker_thinker_id: @task.worker_thinker_id, workload_id: @task.workload_id }
    assert_redirected_to task_path(assigns(:task))
  end

  test "should destroy task" do
    assert_difference('Task.count', -1) do
      delete :destroy, id: @task
    end

    assert_redirected_to project_tasks_path(@task.project_id)
  end
end
