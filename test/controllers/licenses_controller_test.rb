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

class LicensesControllerTest < ActionController::TestCase
  setup do
    @license = licenses(:mit)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:licenses)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create license" do
    assert_difference('License.count') do
      post :create, license: { description: "The license allows the user of the software the freedom to use the software for any purpose, to distribute it, to modify it, and to distribute modified versions of the software, under the terms of the license, without concern for royalties.", name: "Apache License", url: "https://en.wikipedia.org/wiki/Apache_License" }
    end

    assert_redirected_to license_path(assigns(:license))
  end

  test "should show license" do
    get :show, id: @license
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @license
    assert_response :success
  end

  test "should update license" do
    patch :update, id: @license, license: { description: @license.description, name: @license.name, url: @license.url }
    assert_redirected_to license_path(assigns(:license))
  end

  test "should destroy license" do
    assert_difference('License.count', -1) do
      delete :destroy, id: @license
    end

    assert_redirected_to licenses_path
  end

  test "should check uniqueness's name" do
    assert_no_difference('License.count') do
      post :create, license: { description: @license.description, name: @license.name, url: @license.url }
    end
  end

  test "should check length of name between 1 and 50" do
    assert_no_difference('License.count') do
      post :create, license: { description: "License description", name: "", url: "" }
    end

    too_long_title = random_string(51)
    
    assert_no_difference('License.count') do
      post :create, license: { description: "License description", name: too_long_title, url: "" }
    end
  end

  test "should check length of description between 2 and 1600" do
    assert_no_difference('License.count') do
      post :create, license: { description: "", name: "Open License", url: "" }
    end

    too_long_description = random_string(1601)
    
    assert_no_difference('License.count') do
      post :create, license: { description: too_long_description, name: "Open License", url: "" }
    end
  end
end
