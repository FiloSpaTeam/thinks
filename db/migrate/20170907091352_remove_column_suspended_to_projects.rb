class RemoveColumnSuspendedToProjects < ActiveRecord::Migration
  def up
    remove_column :projects, :suspended
  end

  def down
    add_column :projects, :suspended, :boolean, default: false
  end
end
