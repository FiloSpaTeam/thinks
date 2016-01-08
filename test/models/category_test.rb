require 'test_helper'

class CategoryTest < ActiveSupport::TestCase
  test 'should not save category without name' do
    category = categories(:games)

    category.t_name = nil

    assert_not category.save, 'Saved category with empty name'
  end

  test 'should not save category without description' do
    category = categories(:games)

    category.t_description = nil

    assert_not category.save, 'Saved category with empty description'
  end
end
