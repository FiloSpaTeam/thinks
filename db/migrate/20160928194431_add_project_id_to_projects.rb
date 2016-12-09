class AddProjectIdToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :project_id, :integer
  end
end
