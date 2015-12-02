class RemoveColumnGoalToSprints < ActiveRecord::Migration
  def up
    remove_column :sprints, :goal
  end

  def down
    add_column :sprints, :goal, :integer
  end
end
