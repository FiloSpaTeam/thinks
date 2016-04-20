require 'test_helper'

class TasksControllerTest < ActionController::TestCase
  setup do
    @task = tasks(:task_one)

    authenticate
  end

  test 'should get index' do
    get :index, project_id: @task.project_id
    assert_response :success
    assert_not_nil assigns(:tasks)
  end

  test 'should get new' do
    become_member

    get :new, project_id: @task.project_id
    assert_response :success
  end

  test 'should create task' do
    become_member

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
