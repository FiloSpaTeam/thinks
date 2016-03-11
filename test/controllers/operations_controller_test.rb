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
