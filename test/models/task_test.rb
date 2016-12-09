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

class TaskTest < ActiveSupport::TestCase
  test 'should not save task if project is empty' do
    task = Task.new
    task.title       = 'The best title'
    task.description = 'The best description in the world, very useful. I think that: we can win together!'
    task.project_id  = nil
    task.thinker_id  = 135138680
    task.status_id   = 2527749

    assert_not task.save, 'Saved task without related project.'
  end

  test 'should not save task if thinker is empty' do
    task = Task.new
    task.title       = 'The best title'
    task.description = 'The best description in the world, very useful. I think that: we can win together!'
    task.thinker_id  = nil
    task.project_id  = 1
    task.status_id   = 2527749

    assert_not task.save, 'Saved task without related thinker.'
  end

  test 'should not save task if status is empty' do
    task = Task.new
    task.title       = 'The best title'
    task.description = 'The best description in the world, very useful. I think that: we can win together!'
    task.project_id  = 1
    task.thinker_id  = 135138680

    assert task.save, 'Saved task without related status.'
  end

  test 'should not save task if title is empty' do
    task = Task.new
    task.title       = nil
    task.description = 'The best description in the world, very useful. I think that: we can win together!'
    task.project_id  = 1
    task.thinker_id  = 135138680
    task.status_id   = 2527749

    assert_not task.save, 'Saved task without title.'
  end

  test 'should not save task if title is greater than 60' do
    task = Task.new
    task.title       = random_string(61)
    task.description = 'The best description in the world, very useful. I think that: we can win together!'
    task.project_id  = 1
    task.thinker_id  = 135138680
    task.status_id   = 2527749

    assert_not task.save, 'Saved task with too long title.'
  end

  test 'should not save task if description is empty' do
    task = Task.new
    task.title       = random_string(55)
    task.description = nil
    task.project_id  = 1
    task.thinker_id  = 135138680
    task.status_id   = 2527749

    assert_not task.save, 'Saved task without description.'
  end

  test 'should not save task if description length is less than 30' do
    task = Task.new
    task.title       = random_string(55)
    task.description = random_string(29)
    task.project_id  = 1
    task.thinker_id  = 135138680
    task.status_id   = 2527749

    assert_not task.save, 'Saved task with too short description.'
  end
end
