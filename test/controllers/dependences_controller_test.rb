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
