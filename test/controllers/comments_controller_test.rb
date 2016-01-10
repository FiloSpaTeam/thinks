require 'test_helper'

class CommentsControllerTest < ActionController::TestCase
  setup do
    @comment = comments(:comment_one)

    authenticate
  end

  test 'should create comment' do
    task = tasks(:task_one)

    assert_difference('Comment.count') do
      post :create, task_id: task.id, comment:
        { text: 'New comment', approved: true, thinker_id: 135_138_680 }
    end

    assert_redirected_to task_path(task)
  end
end
