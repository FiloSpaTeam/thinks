require 'test_helper'

class LikesControllerTest < ActionController::TestCase
  setup do
    @like = likes(:like_one)

    authenticate
  end

  test 'should create like' do
    comment = comments(:comment_one)

    assert_difference('Like.count') do
      post :create, comment_id: comment.id
    end

    assert_redirected_to task_path(comment.task)
  end
end
