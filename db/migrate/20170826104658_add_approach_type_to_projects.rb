class AddApproachTypeToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :approach_type, :integer, default: 0
  end
end
