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
