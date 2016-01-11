require 'test_helper'

class TaskTest < ActiveSupport::TestCase
  test 'should not save task if project is empty' do
    task = tasks(:task_one)

    task.project_id = nil

    assert_not task.save, 'Saved task without related project.'
  end

  test 'should not save task if thinker is empty' do
    task = tasks(:task_one)

    task.thinker_id = nil

    assert_not task.save, 'Saved task without related thinker.'
  end

  test 'should not save task if status is empty' do
    task = tasks(:task_one)

    task.status_id = nil

    assert_not task.save, 'Saved task without related thinker.'
  end

  test 'should not save task if title is empty' do
    task = tasks(:task_one)

    task.title = nil

    assert_not task.save, 'Saved task without title.'
  end

  test 'should not save task if title is greater than 60' do
    task = tasks(:task_one)

    task.title = random_string(61)

    assert_not task.save, 'Saved task with too long title.'
  end

  test 'should not save task if description is empty' do
    task = tasks(:task_one)

    task.description = nil

    assert_not task.save, 'Saved task without description.'
  end

  test 'should not save task if description length is less than 30' do
    task = tasks(:task_one)

    task.description = random_string(29)

    assert_not task.save, 'Saved task with too short description.'
  end
end
