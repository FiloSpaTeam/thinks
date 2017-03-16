class AddContributionTextToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :contribution_text, :text
  end
end
