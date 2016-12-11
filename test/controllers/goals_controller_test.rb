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

class GoalsControllerTest < ActionController::TestCase
  setup do
    @goal = goals(:notification_system)

    authenticate
  end

  test 'should get index' do
    get :index, project_id: @goal.project
    assert_response :success
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
