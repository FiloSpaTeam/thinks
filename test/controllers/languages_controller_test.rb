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
