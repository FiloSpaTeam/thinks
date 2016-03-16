class RenameContributionTypeToContributions < ActiveRecord::Migration
  def change
    rename_column :contributions, :contribution_type, :intensity
  end
end
