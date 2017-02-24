class AddContributionTypeToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :contribution_type, :integer, default: 0
  end
end
