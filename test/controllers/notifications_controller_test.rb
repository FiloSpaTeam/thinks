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

class NotificationsControllerTest < ActionController::TestCase
  setup do
    @notification = notifications(:one)

    authenticate
  end

  test 'should get index' do
    get :index
    assert_response :success
    assert_not_nil assigns(:notifications)
  end

  test 'should get new' do
    get :new
    assert_response :success
  end

  test 'should create notification' do
    assert_difference('Notification.count') do
      post :create, notification: { project_id: @notification.project_id, thinker_id: @notification.thinker_id }
    end

    assert_redirected_to notification_path(assigns(:notification))
  end

  test 'should show notification' do
    get :show, id: @notification
    assert_response :success
  end

  test 'should get edit' do
    get :edit, id: @notification
    assert_response :success
  end

  test 'should update notification' do
    patch :update, id: @notification, notification: { project_id: @notification.project_id, thinker_id: @notification.thinker_id }
    assert_redirected_to notification_path(assigns(:notification))
  end

  test 'should destroy notification' do
    assert_difference('Notification.count', -1) do
      delete :destroy, id: @notification
    end

    assert_redirected_to notifications_path
  end
end
