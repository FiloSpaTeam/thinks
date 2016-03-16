class AddContributionTypeToProjectsThinkers < ActiveRecord::Migration
  def change
    add_column :projects_thinkers, :contribution_type, :integer, default: 0
  end
end
