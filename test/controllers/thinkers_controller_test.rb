require 'test_helper'

class ThinkersControllerTest < ActionController::TestCase

  def setup
    @request.env["devise.mapping"] = Devise.mappings[:thinker]
  end

  setup do
    @thinker = thinkers(:admin)
  end

  test "should get new registration" do
    @controller = Devise::RegistrationsController.new
    get :new

    assert_response :success
  end

  test "should get new session" do
    @controller = Devise::SessionsController.new
    get :new

    assert_response :success
  end
end
