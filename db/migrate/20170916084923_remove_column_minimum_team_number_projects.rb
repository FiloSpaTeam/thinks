class RemoveColumnMinimumTeamNumberProjects < ActiveRecord::Migration
  def up
    remove_column :projects, :minimum_team_number
  end

  def down
    add_column :projects, :minimum_team_number, :integer, default: 2
  end
end
