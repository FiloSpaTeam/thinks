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
