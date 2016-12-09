class RenameProjectsThinkersToContributions < ActiveRecord::Migration
  def up
    rename_table :projects_thinkers, :contributions
  end

  def down
    rename_table :contributions, :projects_thinkers
  end
end
