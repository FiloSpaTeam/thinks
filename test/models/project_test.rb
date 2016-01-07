require 'test_helper'

class ProjectTest < ActiveSupport::TestCase
  test 'should not save project if minimum team number is less than 2' do
    project = projects(:rethink)

    project.minimum_team_number = 0

    assert_not project.save, 'Saved the project with no team members.'
  end

  test 'should not save project if minimum team number is not an integer' do
    project = projects(:rethink)

    project.minimum_team_number = 2.45

    assert_not project.save, 'Saved the project with 2.45 members.'
  end

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
