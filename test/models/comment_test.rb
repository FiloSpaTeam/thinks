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

class CommentTest < ActiveSupport::TestCase
  test 'should not save comment with more 2000 chars.' do
    comment = comments(:comment_one)

    comment.text = random_string(2001)

    assert_not comment.save, 'Saved a comment too long.'
  end

  test 'should not save empty comment' do
    comment = comments(:comment_one)

    comment.text = nil

    assert_not comment.save, 'Saved an empty comment.'
  end

  test 'should not save comment without related thinker' do
    comment = comments(:comment_one)

    comment.thinker = nil

    assert_not comment.save, 'Saved a comment without thinker.'
  end

  test 'should not save comment without related task' do
    comment = comments(:comment_one)

    comment.task = nil

    assert_not comment.save, 'Saved a comment without task.'
  end
end
