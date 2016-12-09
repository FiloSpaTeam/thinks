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

class GoalTest < ActiveSupport::TestCase
  test 'should not save goal if title is empty or length is over 60' do
    goal = goals(:notification_system)

    goal.title = ''
    assert_not goal.save, 'Saved the goal with an empty title.'

    goal.title = random_string(61)
    assert_not goal.save, 'Saved the goal with a too long title.'
  end

  test 'should not save goal if description length is less than 30' do
    goal = goals(:notification_system)

    goal.description = random_string(29)
    assert_not goal.save, 'Saved the goal with too short description.'
  end

  test 'should not save goal if progress is less than 0' do
    goal = goals(:notification_system)

    goal.progress = -1
    assert_not goal.save, 'Saved the goal with progress less than 0.'
  end

  test 'should not save goal if progress is more than 100' do
    goal = goals(:notification_system)

    goal.progress = 101
    assert_not goal.save, 'Saved the goal with progress less than 0.'
  end
end
