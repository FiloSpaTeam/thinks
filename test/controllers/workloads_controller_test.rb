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

class WorkloadsControllerTest < ActionController::TestCase
  setup do
    @workload = workloads(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:workloads)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create workload" do
    assert_difference('Workload.count') do
      post :create, workload: { value: @workload.value }
    end

    assert_redirected_to workload_path(assigns(:workload))
  end

  test "should show workload" do
    get :show, id: @workload
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @workload
    assert_response :success
  end

  test "should update workload" do
    patch :update, id: @workload, workload: { value: @workload.value }
    assert_redirected_to workload_path(assigns(:workload))
  end

  test "should destroy workload" do
    assert_difference('Workload.count', -1) do
      delete :destroy, id: @workload
    end

    assert_redirected_to workloads_path
  end
end
