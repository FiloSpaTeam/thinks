class ChangeColumnsToNotifications < ActiveRecord::Migration
  def up
    remove_column :notifications, :sprint_id
    remove_column :notifications, :goal_id
    remove_column :notifications, :task_id

    add_column :notifications, :model, :string
    add_column :notifications, :model_id, :integer
  end

  def down
    add_column :notifications, :sprint_id, :integer
    add_column :notifications, :goal_id, :integer
    add_column :notifications, :task_id, :integer

    remove_column :notifications, :model
    remove_column :notifications, :model_id
  end
end
