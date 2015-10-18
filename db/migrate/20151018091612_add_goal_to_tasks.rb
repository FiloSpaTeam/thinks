class AddGoalToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :goal_id, :integer
  end
end
