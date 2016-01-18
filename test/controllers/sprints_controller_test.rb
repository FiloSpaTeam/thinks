require 'test_helper'

class SprintsControllerTest < ActionController::TestCase
  setup do
    @sprint = sprints(:one)

    authenticate
  end

  test "should get index" do
    get :index, project_id: 1
    assert_response :success
    assert_not_nil assigns(:sprints)
  end

  test "should create sprint" do
    assert_difference('Sprint.count') do
      post :create, project_id: @sprint.project_id, sprint: { project_id: @sprint.project_id }
    end

    assert_redirected_to sprint_path(assigns(:sprint))
  end

  test "should show sprint" do
    get :show, id: @sprint
    assert_response :success
  end

  test "should update sprint" do
    patch :update, id: @sprint, sprint: { obtained: @sprint.obtained, project_id: @sprint.project_id }
    assert_redirected_to sprint_path(assigns(:sprint))
  end
end
