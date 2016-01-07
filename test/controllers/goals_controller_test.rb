require 'test_helper'

class GoalsControllerTest < ActionController::TestCase
  setup do
    @goal = goals(:notification_system)

    authenticate
  end

  test 'should get index' do
    get :index, project_id: @goal.project
    assert_response :success
    assert_not_nil assigns(:goals)
  end

  test 'should get new' do
    get :new, project_id: @goal.project
    assert_response :success
  end

  test 'should create goal' do
    assert_difference('Goal.count') do
      post :create, project_id: @goal.project_id, goal: { title: 'Auth system', description: 'All related to authentication system, excluded OAuth!', project_id: @goal.project_id, thinker_id: 135_138_680 }
    end

    assert_redirected_to goal_path(assigns(:goal))
  end

  test 'should show goal' do
    get :show, id: @goal
    assert_response :success
  end

  test 'should get edit' do
    get :edit, id: @goal
    assert_response :success
  end

  test 'should update goal' do
    patch :update, id: @goal, goal: {  }
    assert_redirected_to goal_path(assigns(:goal))
  end

  test 'should destroy goal' do
    assert_difference('Goal.count', -1) do
      delete :destroy, id: @goal
    end

    assert_redirected_to goals_path
  end
end
