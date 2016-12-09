class AddCycleToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :cycle_id, :integer
  end
end
