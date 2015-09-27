require 'test_helper'

class DependencesControllerTest < ActionController::TestCase
  setup do
    @dependence = dependences(:ogre)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:dependences)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create dependence" do
    assert_difference('Dependence.count') do
      post :create, dependence: { reason: "I think this library solves a big problem about SSH support...." }
    end

    assert_redirected_to dependence_path(assigns(:dependence))
  end

  test "should show dependence" do
    get :show, id: @dependence
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @dependence
    assert_response :success
  end

  test "should update dependence" do
    patch :update, id: @dependence, dependence: {  }
    assert_redirected_to dependence_path(assigns(:dependence))
  end

  test "should destroy dependence" do
    assert_difference('Dependence.count', -1) do
      delete :destroy, id: @dependence
    end

    assert_redirected_to dependences_path
  end

  test "should check url presence if external" do
    assert_no_difference('Dependence.count') do
      post :create, dependence: { external: true, reason: "I think this library solves a big problem about SSH support....", url: "" }
    end
  end

  test "should check reason's length between 20 and 1600" do
    too_short_string = random_string(19)

    assert_no_difference('Dependence.count') do
      post :create, dependence: { external: true, reason: too_short_string, url: "" }
    end

    too_long_string = random_string(1601)

    assert_no_difference('Dependence.count') do
      post :create, dependence: { external: true, reason: too_long_string, url: "" }
    end
  end
end
