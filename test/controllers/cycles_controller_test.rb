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

class CyclesControllerTest < ActionController::TestCase
  setup do
    @cycle = cycles(:one_week)
  end

  test 'should get index' do
    get :index
    assert_response :success
    assert_not_nil assigns(:cycles)
  end

  test 'should get new' do
    get :new
    assert_response :success
  end

  test 'should create cycle' do
    assert_difference('Cycle.count') do
      post :create, cycle: { days: @cycle.days, description: @cycle.description, translation_code: @cycle.translation_code }
    end

    assert_redirected_to cycle_path(assigns(:cycle))
  end

  test 'should show cycle' do
    get :show, id: @cycle
    assert_response :success
  end

  test 'should get edit' do
    get :edit, id: @cycle
    assert_response :success
  end

  test 'should update cycle' do
    patch :update, id: @cycle, cycle: { days: @cycle.days, description: @cycle.description, translation_code: @cycle.translation_code }
    assert_redirected_to cycle_path(assigns(:cycle))
  end

  test 'should destroy cycle' do
    assert_difference('Cycle.count', -1) do
      delete :destroy, id: @cycle
    end

    assert_redirected_to cycles_path
  end
end
