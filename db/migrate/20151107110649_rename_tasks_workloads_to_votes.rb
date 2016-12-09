class RenameTasksWorkloadsToVotes < ActiveRecord::Migration
  def change
    rename_table :tasks_workloads, :votes
  end
end
