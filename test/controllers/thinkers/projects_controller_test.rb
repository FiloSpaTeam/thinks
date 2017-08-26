require 'test_helper'

class Thinkers::ProjectsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

end
