class AddStatusToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :status, :integer, default: 0
  end
end
