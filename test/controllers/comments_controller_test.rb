require 'test_helper'

class CommentsControllerTest < ActionController::TestCase
  setup do
    @comment = comments(:comment_one)

    authenticate
  end

  test 'should create comment' do
    assert_difference('Comment.count') do
      post :create, task_id: 1_044_935_394, comment:
        { text: 'New comment', approved: true, thinker_id: 135_138_680 }
    end
  end
end
