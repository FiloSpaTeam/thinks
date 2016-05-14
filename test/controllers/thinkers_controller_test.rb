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

class ThinkersControllerTest < ActionController::TestCase

  def setup
    @request.env['devise.mapping'] = Devise.mappings[:thinker]
  end

  setup do
    @thinker = thinkers(:admin)
  end

  test 'should get new registration' do
    @controller = Thinkers::RegistrationsController.new
    get :new

    assert_response :success
  end

  test 'should get new session' do
    @controller = Thinkers::SessionsController.new
    get :new

    assert_response :success
  end
end
