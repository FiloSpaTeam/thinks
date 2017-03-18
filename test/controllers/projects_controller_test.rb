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

class ProjectsControllerTest < ActionController::TestCase
  setup do
    @project = projects(:rethink)

    authenticate
  end

  test 'should get index' do
    get :index
    assert_response :success
  end

  test 'should get new' do
    get :new
    assert_response :success
  end

  test 'should create project' do
    assert_difference('Project.count') do
      post :create, project: { release_at: Date.today, description: "Fantastic project", minimum_team_number: 5, title: "Eureka", license_id: 471458987, home_url: "http://myurl.org/", source_code_url: "http://myurl.org/src", documentation_url: "http://myurl.org/doc", cycle_id: 788802281, category_id: 298486374, thinker_id: 135138680, motto: 'Always resist.' }
    end

    assert_redirected_to project_path(assigns(:project))
  end

  test 'should show project' do
    get :show, id: @project
    assert_response :success
  end

  test 'should get edit' do
    get :edit, id: @project
    assert_response :success
  end

  test 'should update project' do
    patch :update, id: @project, project: { release_at: @project.release_at, description: @project.description, minimum_team_number: @project.minimum_team_number, title: @project.title, license_id: @project.license_id, home_url: @project.home_url, source_code_url: @project.source_code_url, documentation_url: @project.documentation_url }
    assert_redirected_to project_path(assigns(:project))
  end

  test 'should destroy project' do
    assert_difference('Project.count', -1) do
      delete :destroy, id: @project
    end

    assert_redirected_to projects_path
  end
end
