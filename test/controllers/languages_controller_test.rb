require 'test_helper'

class LanguagesControllerTest < ActionController::TestCase
  setup do
    @language = languages(:ruby)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:languages)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create language" do
    assert_difference('Language.count') do
      post :create, language: { name: "Perl" }
    end

    assert_redirected_to language_path(assigns(:language))
  end

  test "should show language" do
    get :show, id: @language
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @language
    assert_response :success
  end

  test "should update language" do
    patch :update, id: @language, language: { name: @language.name }
    assert_redirected_to language_path(assigns(:language))
  end

  test "should destroy language" do
    assert_difference('Language.count', -1) do
      delete :destroy, id: @language
    end

    assert_redirected_to languages_path
  end

  test "should check uniqueness" do
    assert_no_difference('Language.count') do
      post :create, language: { name: @language.name }
    end
  end

  test "should check length between 1 and 25" do
    too_long_name = random_string(26)

    assert_no_difference('Language.count') do
      post :create, language: { name: "" }
    end

    assert_no_difference('Language.count') do
      post :create, language: { name: too_long_name }
    end
  end
end
