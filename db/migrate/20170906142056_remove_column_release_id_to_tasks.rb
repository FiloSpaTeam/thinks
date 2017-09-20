class RemoveColumnReleaseIdToTasks < ActiveRecord::Migration
  def up
    remove_column :tasks, :release_id
  end

  def down
    add_column :tasks, :release_id, :integer
  end
end
