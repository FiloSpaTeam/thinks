require 'test_helper'

class RecruitmentsControllerTest < ActionController::TestCase
  setup do
    @task = tasks(:task_recruitment)

    authenticate
  end

  test 'should get index' do
    get :index, project_id: @task.project_id
    assert_response :redirect
  end
end
