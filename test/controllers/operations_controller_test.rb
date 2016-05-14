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

class OperationsControllerTest < ActionController::TestCase
  setup do
    @operation = operations(:one)

    authenticate
  end

  test "should get index" do
    get :index, task_id: @operation.task_id
    assert_response :success
    assert_not_nil assigns(:operations)
  end

  test "should create operation" do
    assert_difference('Operation.count') do
      post :create, task_id: @operation.task_id, operation: { done: @operation.done, serial: @operation.serial + 1, text: @operation.text, task_id: @operation.task_id }
    end

    assert_redirected_to task_operations_path(@operation.task)
  end

  test "should destroy operation" do
    assert_difference('Operation.count', -1) do
      delete :destroy, id: @operation
    end

    assert_redirected_to task_operations_path(@operation.task)
  end
end
