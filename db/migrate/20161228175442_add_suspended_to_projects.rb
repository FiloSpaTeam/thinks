class AddSuspendedToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :suspended, :boolean, default: false
  end
end
