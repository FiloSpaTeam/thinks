require 'test_helper'

class CommentTest < ActiveSupport::TestCase
  test 'should not save comment with more 240 chars.' do
    comment = comments(:comment_one)

    comment.text = random_string(241)

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
