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
