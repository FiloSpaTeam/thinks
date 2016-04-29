require 'test_helper'

class ElectionPollsControllerTest < ActionController::TestCase
  setup do
    @election_poll = election_polls(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:election_polls)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create election_poll" do
    assert_difference('ElectionPoll.count') do
      post :create, election_poll: {  }
    end

    assert_redirected_to election_poll_path(assigns(:election_poll))
  end

  test "should show election_poll" do
    get :show, id: @election_poll
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @election_poll
    assert_response :success
  end

  test "should update election_poll" do
    patch :update, id: @election_poll, election_poll: {  }
    assert_redirected_to election_poll_path(assigns(:election_poll))
  end

  test "should destroy election_poll" do
    assert_difference('ElectionPoll.count', -1) do
      delete :destroy, id: @election_poll
    end

    assert_redirected_to election_polls_path
  end
end
