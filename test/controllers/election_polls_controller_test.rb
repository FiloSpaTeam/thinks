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

class ElectionPollsControllerTest < ActionController::TestCase
  setup do
    @election_poll = election_polls(:one)
  end

  # test "should get index" do
  #   get :index
  #   assert_response :success
  #   assert_not_nil assigns(:election_polls)
  # end

  # test "should get new" do
  #   get :new
  #   assert_response :success
  # end

  # test "should create election_poll" do
  #   assert_difference('ElectionPoll.count') do
  #     post :create, election_poll: {  }
  #   end

  #   assert_redirected_to election_poll_path(assigns(:election_poll))
  # end

  # test "should show election_poll" do
  #   get :show, id: @election_poll
  #   assert_response :success
  # end

  # test "should get edit" do
  #   get :edit, id: @election_poll
  #   assert_response :success
  # end

  # test "should update election_poll" do
  #   patch :update, id: @election_poll, election_poll: {  }
  #   assert_redirected_to election_poll_path(assigns(:election_poll))
  # end

  # test "should destroy election_poll" do
  #   assert_difference('ElectionPoll.count', -1) do
  #     delete :destroy, id: @election_poll
  #   end

  #   assert_redirected_to election_polls_path
  # end
end
