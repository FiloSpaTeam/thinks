class AddConditionToProjects < ActiveRecord::Migration[5.2]
  def change
    add_column :projects, :condition, :integer, :default => 0
  end
end
