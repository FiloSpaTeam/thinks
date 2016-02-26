require 'test_helper'

class SurveyControllerTest < ActionController::TestCase
  setup do
    @sprint = sprints(:one)

    authenticate
  end

  test 'should get index' do
    get :index, sprint_id: @sprint.id

    assert_response :redirect
  end

  test 'should get new' do
    get :new, sprint_id: @sprint.id
    assert_response :success
  end

end
