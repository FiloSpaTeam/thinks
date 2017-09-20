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

class ProjectTest < ActiveSupport::TestCase
  test 'should not save project if title is less than 2 or more than 60' do
    project = projects(:rethink)

    project.title = ''
    assert_not project.save, 'Saved the project with no title.'

    project.title = random_string(61)
    assert_not project.save, 'Saved the project with too long title.'
  end

  test 'should not save project if title is not unique' do
    project = projects(:rethink)

    project.title = 'Savage'

    assert_not project.save, 'Saved the project with duplicated title.'
  end

  test 'should not save project if description is less than 2 or more than 1600' do
    project = projects(:rethink)

    project.description = ''
    assert_not project.save, 'Saved the project with no description.'

    project.description = random_string(1601)
    assert_not project.save, 'Saved the project with too long description.'
  end
end
