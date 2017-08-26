class AddVisibleToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :visible, :boolean, default: false
  end
end
